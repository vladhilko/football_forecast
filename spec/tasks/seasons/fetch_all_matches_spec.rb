# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rake seasons:fetch_all_matches', type: :task do
  subject { Rake::Task['seasons:fetch_all_matches'].execute(task_arguments) }

  context 'when rake task params are valid' do
    before do
      expect(OddsportalScraper).to receive(:matches)
        .with(sport: 'soccer', country: england.name, league: premier_league.name, season: season_2021_2022.name)
        .and_return(matches)
    end

    let(:task_arguments) do
      {
        country: england.name,
        league: premier_league.name,
        season: season_2021_2022.name
      }
    end

    let(:england) { create(:country, name: 'England') }
    let(:premier_league) { create(:league, country: england, name: 'Premier League') }
    let(:season_2021_2022) { create(:season, league: premier_league, name: '2021/2022') }

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
          "participants": 'Fulham - Cardiff',
          "score": '1:2',
          "odds": {
            "home_win": '2.04',
            "draw": '3.48',
            "away_win": '3.70'
          }
        }
      ]
    end

    let(:expected_output) do
      <<~TEXT
        Start creating matches for England Premier League 2021/2022:
        2 matches have been added to the DB
      TEXT
    end

    it 'saves all fetched matches to the db' do
      expect { subject }.to change(Match, :count).by(2)
        .and change(BettingOdds, :count).by(2)
        .and output(expected_output).to_stdout

      match_1 = Match.first
      expect(match_1).to have_attributes(
        home_team: 'Brentford',
        away_team: 'Fulham',
        score: '1:2 ET',
        date: '04 Aug 2021'.to_date,
        season: season_2021_2022
      )
      expect(match_1.betting_odds).to have_attributes(
        home_team_win: 2.13,
        draw: 3.16,
        away_team_win: 3.82
      )
    end
  end

  context 'when rake task params are invalid' do
    let(:task_arguments) do
      {
        country: 'invalid',
        league: 'invalid',
        season: 'invalid'
      }
    end

    it 'raises Errors::SeasonNotFound' do
      expect { subject }.to raise_error(Errors::SeasonNotFound, 'Please check provided params')
    end
  end
end
