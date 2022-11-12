# frozen_string_literal: true

require 'rails_helper'

describe Seasons::PopulateMatches::EntryPoint do
  subject { described_class.call(season:) }

  let(:england) { create(:country, name: 'England') }
  let(:premier_league) { create(:league, country: england, name: 'Premier League') }
  let(:season) { create(:season, league: premier_league, name: '2021/2022') }
  let(:matches) do
    [
      {
        "match_date": '04 Aug 2021',
        "match_time": '19:45',
        "participants": 'Brentford - Fulham',
        "score": '1:2 ET',
        "odds": {
          "home_win": '2.13',
          "draw": '3.16',
          "away_win": '3.82'
        }
      },
      {
        "match_date": '30 Jul 2021',
        "match_time": '19:45',
        "participants": 'Fulham - Brentford',
        "score": '1:2',
        "odds": {
          "home_win": '2.04',
          "draw": '3.48',
          "away_win": '3.70'
        }
      }
    ]
  end

  before do
    expect(OddsportalScraper).to receive(:matches)
      .with(sport: 'soccer', country: england.name, league: premier_league.name, season: season.name)
      .and_return(matches)
  end

  it 'populates database with all matches for the given season' do
    expect { subject }.to change(Match, :all).from([]).to(
      [
        an_object_having_attributes(
          home_team: 'Brentford',
          away_team: 'Fulham',
          score: '1:2 ET',
          date: '04 Aug 2021'.to_date,
          season:,
          betting_odds: an_object_having_attributes(
            home_team_win: 2.13,
            draw: 3.16,
            away_team_win: 3.82
          )
        ),
        an_object_having_attributes(
          home_team: 'Fulham',
          away_team: 'Brentford',
          score: '1:2',
          date: '30 Jul 2021'.to_date,
          season:,
          betting_odds: an_object_having_attributes(
            home_team_win: 2.04,
            draw: 3.48,
            away_team_win: 3.70
          )
        )
      ]
    ).and change { season.reload.completeness_status }.from('initial').to('full')
  end
end
