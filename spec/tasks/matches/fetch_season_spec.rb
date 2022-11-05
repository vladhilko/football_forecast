# frozen_string_literal: true
# # frozen_string_literal: true
#
# require 'rails_helper'
#
# RSpec.describe 'rake matches:fetch_season', type: :task do
#   subject { Rake::Task['matches:fetch_season'].execute }
#
#   before do
#     OddsportalScraper.matches(sport: 'soccer', country: 'England', league: 'Premier League', season: '2021/2022')
#     expect(OddsportalScraper).to receive(:matches)
#       .with(sport: 'soccer', country: england.name, league: premier_league.name, season: season_2021_2022.name)
#       .and_return(['2007/2008', '2008/2009'])
#   end
#
#   let(:england) { create(:country, name: 'England') }
#   let(:premier_league) { create(:league, country: england, name: 'Premier League') }
#   let(:season_2021_2022) { create(:season, league: premier_league, name: '2021/2022') }
#
#   let(:matches) do
#     [
#       {
#         "match_date": "04 Aug 2020",
#         "match_time": "19:45",
#         "participants": "Brentford - Fulham",
#         "score": "1:2 ET",
#         "odds": {
#           "home_win": "2.13",
#           "draw": "3.16",
#           "away_win": "3.82"
#         }
#       },
#       {
#         "match_date": "30 Jul 2020",
#         "match_time": "19:45",
#         "participants": "Fulham - Cardiff",
#         "score": "1:2",
#         "odds": {
#           "home_win": "2.04",
#           "draw": "3.48",
#           "away_win": "3.70"
#         }
#       }
#     ]
#   end
#
#   let(:expected_output) do
#     <<~TEXT
#       Adding England Premier League matches:
#       2007/2008
#       2008/2009
#       Adding England Championship matches:
#       2010/2011
#       Adding Spain LaLiga matches:
#       2010/2011
#       2011/2012
#       5 matches have been added to the DB
#     TEXT
#   end
#
#   it 'saves all fetched matches to the db' do
#     expect { subject }.to change(Season, :count).by(5).and output(expected_output).to_stdout
#   end
# end
