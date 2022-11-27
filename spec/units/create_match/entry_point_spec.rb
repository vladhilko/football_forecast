# frozen_string_literal: true

require 'rails_helper'

describe CreateMatch::EntryPoint do
  subject { described_class.new(season:, params:).call }

  let(:season) { create(:season) }

  before { freeze_time }

  context 'when params are valid' do
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

    it 'creates a new match record', :aggregate_failures do
      expect { subject }.to change(Match, :count).by(1)
        .and change(BettingOdds, :count).by(1)

      expect(subject).to have_attributes(
        home_team: 'Arsenal',
        away_team: 'Chelsea',
        score: '2:1',
        date: '01.12.2010'.to_date
      )
      expect(subject.betting_odds).to have_attributes(
        home_team_win: 2.34,
        away_team_win: 2.65,
        draw: 3.21
      )
      expect(subject.time.strftime('%H:%M')).to eq('17:00')
    end
  end

  context 'when params are invalid' do
    let(:params) do
      {
        home_team: '',
        away_team: '',
        score: '',
        date: '',
        time: '',
        betting_odds: {
          home_team_win: '',
          away_team_win: '',
          draw: ''
        }
      }
    end

    it 'raises a validation error', :aggregate_failures do
      expect { subject }.to raise_error(Errors::InvalidInputsParams) do |error|
        expect(error.errors[:score]).to contain_exactly('must be filled')
        expect(error.errors[:date]).to contain_exactly('must be filled')
      end
    end
  end
end
