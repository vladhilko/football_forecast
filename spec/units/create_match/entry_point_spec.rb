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
        time: '17:00'
      }
    end

    it 'creates a new match record', :aggregate_failures do
      expect { subject }.to change(Match, :count).by(1)

      match = Match.last
      expect(match).to have_attributes(
        home_team: 'Arsenal',
        away_team: 'Chelsea',
        score: '2:1',
        date: '01.12.2010'.to_date
      )
      expect(match.time.strftime('%H:%M')).to eq('17:00')
    end
  end
end
