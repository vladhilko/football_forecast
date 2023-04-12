# frozen_string_literal: true

require 'rails_helper'

describe Betting::PlaceBet::Form do
  describe '#attributes' do
    subject(:attributes) { described_class.new(params:).attributes }

    let(:params) do
      {
        bet_amount: 100,
        team: 'Arsenal',
        bet_type: 'win'
      }
    end

    it 'returns correct attributes' do
      expect(attributes).to eq(
        {
          bet_amount: 100,
          team: 'Arsenal',
          bet_type: 'win'
        }
      )
    end
  end
end
