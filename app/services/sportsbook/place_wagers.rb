# frozen_string_literal: true

module Sportsbook
  class PlaceWagers # rubocop:disable Metrics/ClassLength

    MINIMUM_STAKE_MINOR = 100

    def self.call(user:, session:, selections:, placement_key:)
      new(user:, session:, selections:, placement_key:).call
    end

    def initialize(user:, session:, selections:, placement_key:)
      @user = user
      @session = session
      @selections = Array(selections)
      @placement_key = placement_key.to_s.strip
    end

    def call
      validate_request!
      existing = existing_wagers
      return existing if existing.any?

      Wager.transaction { place_all }
    rescue ActiveRecord::RecordNotUnique
      repeated = existing_wagers
      return repeated if repeated.any?

      raise Error.new('fixture_already_wagered', 'A wager already exists for one of those fixtures', status: :conflict)
    end

    private

    attr_reader :user, :session, :selections, :placement_key

    def existing_wagers
      user.wagers.where(placement_key:).order(:id).to_a
    end

    def place_all
      session.lock!
      ensure_betting_open!
      wallet = user.wallet.lock!
      prepared = prepare_wagers
      ensure_funds!(wallet, prepared)
      persist_wagers(wallet, prepared)
    end

    def ensure_betting_open!
      return if session.status == 'betting'

      raise Error.new('betting_closed', 'Betting is closed for this round', status: :conflict)
    end

    def ensure_funds!(wallet, prepared)
      total_stake = prepared.sum { _1.fetch(:stake_minor) }
      raise Error.new('insufficient_funds', 'Wallet balance is too low') if total_stake > wallet.balance_minor
    end

    def validate_request!
      validate_presence!

      fixture_ids = selections.map { _1[:fixture_id] || _1['fixture_id'] }
      return if fixture_ids.compact.uniq.size == selections.size

      raise Error.new('duplicate_fixture', 'The bet slip contains the same fixture more than once')
    end

    def validate_presence!
      raise Error.new('idempotency_key_required', 'Idempotency-Key header is required') if placement_key.empty?
      raise Error.new('empty_bet_slip', 'Choose at least one fixture before placing bets') if selections.empty?
    end

    def prepare_wagers
      selections.map { prepare_selection(_1.to_h.with_indifferent_access) }
    rescue ActiveRecord::RecordNotFound
      raise Error.new('fixture_not_found', 'One of the selected fixtures is not part of this round', status: :not_found)
    end

    def prepare_selection(attributes)
      session_match = session.session_matches.find_by!(uuid: attributes[:fixture_id])
      choice = attributes[:selection].to_s
      validate_choice!(choice)
      stake_minor = validated_stake(attributes[:stake_minor])
      odds = session_match.odds_for(choice)
      { session_match:, choice:, stake_minor:, odds:, potential_payout_minor: payout(stake_minor, odds) }
    end

    def validate_choice!(choice)
      return if Wager::SELECTIONS.include?(choice)

      raise Error.new('invalid_selection', 'Selection must be home, draw, or away')
    end

    def validated_stake(value)
      stake = Integer(value, exception: false)
      return stake if stake && stake >= MINIMUM_STAKE_MINOR

      raise Error.new('invalid_stake', 'Stake must be at least 1.00 credit')
    end

    def payout(stake_minor, odds)
      (BigDecimal(stake_minor.to_s) * odds).round(0, BigDecimal::ROUND_HALF_UP).to_i
    end

    def persist_wagers(wallet, prepared)
      balance = wallet.balance_minor
      wagers = prepared.map do |attributes|
        wager = create_wager(attributes)
        balance -= wager.stake_minor
        record_stake(wallet, wager, balance)
        wager
      end
      wallet.update!(balance_minor: balance)
      wagers
    end

    def create_wager(attributes)
      session_match = attributes.fetch(:session_match)
      user.wagers.create!(wager_attributes(attributes, session_match))
    end

    def wager_attributes(attributes, session_match)
      {
        time_travel_session: session, time_travel_session_match: session_match,
        source_match: session_match.source_match, placement_key:, selection: attributes.fetch(:choice),
        stake_minor: attributes.fetch(:stake_minor), decimal_odds: attributes.fetch(:odds),
        potential_payout_minor: attributes.fetch(:potential_payout_minor), placed_at: Time.current
      }
    end

    def record_stake(wallet, wager, balance)
      wallet.wallet_entries.create!(
        wager:, entry_type: 'stake_debit', amount_minor: -wager.stake_minor, balance_after_minor: balance,
        idempotency_key: "#{placement_key}:stake:#{wager.time_travel_session_match.uuid}"
      )
    end

  end
end
