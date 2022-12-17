# frozen_string_literal: true

require 'rails_helper'

describe Seasons::CalculateProfit::Form do
  describe '#attributes' do
    subject(:attributes) { form.attributes }

    let(:form) { described_class.new(params:) }
    let(:params) do
      {
        amount: 100,
        team: 'Chelsea',
        bet_strategy: 'always_win'
      }
    end

    before do
      form.call

      freeze_time
    end

    it 'returns correct attributes' do
      expect(attributes).to eq(
        {
          amount: 100,
          team: 'Chelsea',
          bet_strategy: 'always_win'
        }
      )
    end
  end
end
