# frozen_string_literal: true

module Sportsbook
  class RegisterUser

    OPENING_BALANCE_MINOR = 1_000_000

    def self.call(attributes)
      User.transaction do
        user = User.create!(attributes)
        wallet = user.create_wallet!(balance_minor: OPENING_BALANCE_MINOR, currency: 'PLAY')
        wallet.wallet_entries.create!(opening_entry_attributes(user))
        user
      end
    end

    def self.opening_entry_attributes(user)
      {
        entry_type: 'opening_credit',
        amount_minor: OPENING_BALANCE_MINOR,
        balance_after_minor: OPENING_BALANCE_MINOR,
        idempotency_key: "opening-credit:#{user.uuid}",
        metadata: { reason: 'phase5_signup_bonus' }
      }
    end

  end
end
