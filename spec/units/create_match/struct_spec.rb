# frozen_string_literal: true

require 'rails_helper'

describe CreateMatch::Struct do
  describe '#to_h' do
    subject { described_class.new(params).to_h }

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
      expect(subject.to_h).to eq(
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
      )
    end

    context 'when betting_odds params are empty' do
      let(:params) do
        super().merge({
                        betting_odds: {
                          home_team_win: nil,
                          away_team_win: nil,
                          draw: nil
                        }
                      })
      end

      it 'returns betting odds with defalt values' do
        expect(subject.to_h).to eq(
          {
            home_team: 'Arsenal',
            away_team: 'Chelsea',
            score: '2:1',
            date: '01.12.2010',
            time: '17:00',
            betting_odds: {
              home_team_win: '1',
              away_team_win: '1',
              draw: '1'
            }
          }
        )
      end
    end
  end
end
