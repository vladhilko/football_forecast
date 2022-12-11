# frozen_string_literal: true

require 'rails_helper'

describe Seasons::CalculateProfit::Form do
  describe '#attributes' do
    subject(:attributes) { described_class.new(params:).call.values.data }

    before { freeze_time }

    let(:params) do
      {
        amount: 100,
        team: 'Chelsea',
        betting_strategy: 'always_win'
      }
    end

    it 'returns correct attributes' do
      expect(attributes).to eq(
        {
          amount: 100,
          team: 'Chelsea',
          betting_strategy: 'always_win'
        }
      )
    end
  end
end
