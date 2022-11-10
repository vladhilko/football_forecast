# frozen_string_literal: true

require 'rails_helper'

describe ParamsMappers::OddsportalMatch do
  subject { described_class.call(params:) }

  let(:params) do
    {
      "match_date": '30 Jul 2021',
      "match_time": '19:45',
      "participants": 'Fulham - Cardiff',
      "score": '1:2',
      "odds": {
        "home_win": '2.04',
        "draw": '3.48',
        "away_win": '3.70'
      }
    }
  end

  it 'returns prepared params' do
    expect(subject).to eq(
      {
        home_team: 'Fulham',
        away_team: 'Cardiff',
        score: '1:2',
        date: '30 Jul 2021',
        time: '19:45',
        betting_odds: {
          home_team_win: '2.04',
          draw: '3.48',
          away_team_win: '3.70'
        }
      }
    )
  end
end
