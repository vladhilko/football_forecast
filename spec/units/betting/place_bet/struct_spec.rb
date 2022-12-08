# frozen_string_literal: true

require 'rails_helper'

describe Betting::PlaceBet::Struct do
  describe '#to_h' do
    subject { described_class.new(params).to_h }

    let(:match) { build_stubbed(:match) }

    let(:params) do
      {
        bet_amount: 100,
        team: 'Arsenal',
        bet_type: 'win'
      }
    end

    it 'returns correct attributes' do
      expect(subject).to eq(
        {
          bet_amount: 100,
          team: 'Arsenal',
          bet_type: 'win'
        }
      )
    end
  end
end
