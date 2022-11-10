# frozen_string_literal: true

require 'rails_helper'

describe CreateMatch::Inputs do
  describe '#attributes' do
    subject(:attributes) { described_class.new(params:).call.values.data }

    before { freeze_time }

    let(:params) do
      {
        home_team: 'Arsenal',
        away_team: 'Chelsea',
        score: '2:1',
        date: '01.12.2010',
        time: '17:00',
        betting_odds: {
          home_team_win: '2.34',
          away_team_win: '2.65',
          draw: '3.21'
        }
      }
    end

    it 'returns correct attributes' do
      expect(attributes).to eq(
        {
          home_team: 'Arsenal',
          away_team: 'Chelsea',
          score: '2:1',
          date: '01.12.2010'.to_date,
          time: '17:00',
          betting_odds: {
            home_team_win: 2.34,
            away_team_win: 2.65,
            draw: 3.21
          }
        }
      )
    end

    context 'without optional params' do
      let(:params) { super().except(:time) }

      it 'returns correct attributes' do
        expect(attributes).to eq(
          {
            home_team: 'Arsenal',
            away_team: 'Chelsea',
            score: '2:1',
            date: '01.12.2010'.to_date,
            betting_odds: {
              home_team_win: 2.34,
              away_team_win: 2.65,
              draw: 3.21
            }
          }
        )
      end
    end
  end
end