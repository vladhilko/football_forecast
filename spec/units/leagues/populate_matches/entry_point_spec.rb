# frozen_string_literal: true

require 'rails_helper'

describe Leagues::PopulateMatches::EntryPoint do
  subject { described_class.call(league: premier_league, season_status:) }

  let(:england) { create(:country, name: 'England') }
  let(:premier_league) { create(:league, country: england, name: 'Premier League') }
  let(:season_1) { create(:season, league: premier_league, name: '2020/2021') }
  let(:season_2) { create(:season, league: premier_league, name: '2021/2022') }
  let(:season_status) { Constants.season.completeness_statuses.initial }

  let(:season_1_matches) do
    [
      {
        "match_date": '04 Aug 2020',
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
        "match_date": '30 Jul 2020',
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

  let(:season_2_matches) do
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

  context 'when season is valid' do
    before do
      expect(OddsportalScraper).to receive(:matches)
        .with(sport: 'soccer', country: england.name, league: premier_league.name, season: season_1.name)
        .and_return(season_1_matches)
      expect(OddsportalScraper).to receive(:matches)
        .with(sport: 'soccer', country: england.name, league: premier_league.name, season: season_2.name)
        .and_return(season_2_matches)
    end

    it 'populates database with all matches for the given seasons' do
      expect do
        subject
        season_1.reload
        season_2.reload
      end.to change(season_1, :matches).from([]).to(
        [
          an_object_having_attributes(
            home_team: 'Brentford',
            away_team: 'Fulham',
            score: '1:2 ET',
            date: '04 Aug 2020'.to_date,
            season: season_1,
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
            date: '30 Jul 2020'.to_date,
            season: season_1,
            betting_odds: an_object_having_attributes(
              home_team_win: 2.04,
              draw: 3.48,
              away_team_win: 3.70
            )
          )
        ]
      ).and change(season_2, :matches).from([]).to(
        [
          an_object_having_attributes(
            home_team: 'Brentford',
            away_team: 'Fulham',
            score: '1:2 ET',
            date: '04 Aug 2021'.to_date,
            season: season_2,
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
            season: season_2,
            betting_odds: an_object_having_attributes(
              home_team_win: 2.04,
              draw: 3.48,
              away_team_win: 3.70
            )
          )
        ]
      ).and change(season_1, :completeness_status)
        .from(Constants.season.completeness_statuses.initial).to(Constants.season.completeness_statuses.full)
        .and change(season_2, :completeness_status)
        .from(Constants.season.completeness_statuses.initial).to(Constants.season.completeness_statuses.full)
    end
  end
end
