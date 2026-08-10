# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sportsbook::RegisterUser do
  it 'creates a player, wallet, and immutable opening credit atomically' do
    user = described_class.call(
      display_name: 'Marty', email: 'MARTY@example.com', password: 'password123', password_confirmation: 'password123'
    )

    expect(user).to have_attributes(display_name: 'Marty', email: 'marty@example.com')
    expect(user.wallet).to have_attributes(currency: 'PLAY', balance_minor: 1_000_000)
    expect(user.wallet.wallet_entries.first).to have_attributes(
      entry_type: 'opening_credit', amount_minor: 1_000_000, balance_after_minor: 1_000_000
    )
  end
end
