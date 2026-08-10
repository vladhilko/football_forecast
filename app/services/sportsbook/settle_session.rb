# frozen_string_literal: true

module Sportsbook
  class SettleSession

    def self.call(session:, now: Time.current)
      new(session:, now:).call
    end

    def initialize(session:, now:)
      @session = session
      @now = now
    end

    def call
      TimeTravelSession.transaction { settle_locked_session }
    end

    private

    attr_reader :session, :now

    def settle_locked_session # rubocop:disable Metrics/AbcSize
      session.lock!
      return session if session.status == 'settled'
      return session unless ready?

      wallet = session.user.wallet.lock!
      wallet.update!(balance_minor: settle_wagers(wallet))
      session.update!(status: 'settled', settled_at: now)
      session
    end

    def ready?
      session.status == 'revealing' && session.reveal_deadline && now >= session.reveal_deadline
    end

    def settle_wagers(wallet)
      session.wagers.lock.order(:id).each_with_object([wallet.balance_minor]) do |wager, balance|
        next unless wager.status == 'pending'

        balance[0] = settle_wager(wager, wallet, balance.first)
      end.first
    end

    def settle_wager(wager, wallet, balance)
      winner = wager.time_travel_session_match.final_selection
      won = wager.selection == winner
      payout = won ? wager.potential_payout_minor : 0
      wager.update!(status: won ? 'won' : 'lost', payout_minor: payout, settled_at: now)
      return balance if payout.zero?

      record_payout(wallet, wager, balance + payout)
    end

    def record_payout(wallet, wager, new_balance)
      wallet.wallet_entries.create!(wager:, entry_type: 'payout_credit', amount_minor: wager.payout_minor,
                                    balance_after_minor: new_balance, idempotency_key: "settlement:#{wager.uuid}")
      new_balance
    end

  end
end
