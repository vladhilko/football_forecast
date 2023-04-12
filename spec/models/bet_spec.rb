# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bet, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:match) }
  end

  describe 'default values' do
    it 'sets default value for payout_amount' do
      bet = create(:bet)
      expect(bet.payout_amount).to eq(0)
    end

    it 'sets default value for status' do
      bet = create(:bet)
      expect(bet.status).to eq('pending')
    end
  end
end
