# frozen_string_literal: true

require 'rails_helper'

describe Betting::PlaceBet::EntryPoint do
  subject { described_class.new(match:, params:).call }

  let(:match) { create(:match, home_team: 'Arsenal', away_team: 'Chelsea', score: '2:1') }
  let(:betting_odds) { create(:betting_odds, home_team_win: 2.45, draw: 3.01, away_team_win: 2.78, match:) }

  before { betting_odds }

  context 'when params are valid' do
    let(:params) do
      {
        bet_amount: 100,
        team: 'Arsenal',
        bet_type: 'win'
      }
    end

    it 'creates a new Bet record', :aggregate_failures do
      expect { subject }.to change(Bet, :count).by(1)

      expect(subject).to have_attributes(
        bet_amount: 100,
        team: 'Arsenal',
        bet_type: 'win',
        odds: 2.45,
        payout_amount: 245
      )
    end

    context 'when a bet type is `lose`' do
      let(:params) do
        {
          bet_amount: 100,
          team: 'Arsenal',
          bet_type: 'lose'
        }
      end

      it 'sets correct odds' do
        expect(subject).to have_attributes(
          bet_amount: 100,
          team: 'Arsenal',
          bet_type: 'lose',
          odds: 2.78,
          payout_amount: 278
        )
      end
    end

    context 'when a bet type is `draw`' do
      let(:params) do
        {
          bet_amount: 100,
          team: 'Arsenal',
          bet_type: 'draw'
        }
      end

      it 'sets correct odds' do
        expect(subject).to have_attributes(
          bet_amount: 100,
          team: 'Arsenal',
          bet_type: 'draw',
          odds: 3.01,
          payout_amount: 301
        )
      end
    end
  end
end
