# frozen_string_literal: true

module Tasks
  module Seasons
    class FetchAllMatches

      include Rake::DSL

      def initialize
        namespace :seasons do
          desc 'Fetches all available football matches from the given season to the database'
          task :fetch_all_matches, %i[country league season] => :environment do |_, args|
            @country = Country.find_by(name: args.fetch(:country))
            @league = League.find_by(name: args.fetch(:league), country:)
            @season = Season.find_by(name: args.fetch(:season), league:)

            initial_season_matches_count = season.matches.count

            puts "Start creating matches for #{country.name} #{league.name} #{season.name}:"
            create_all_season_matches

            season_matches_count_after_running_task = season.matches.count - initial_season_matches_count

            puts "#{season_matches_count_after_running_task} matches have been added to the DB"
          end
        end
      end

      private

      attr_reader :country, :league, :season

      def create_all_season_matches
        matches = OddsportalScraper.matches(sport: 'soccer', country: country.name, league: league.name,
                                            season: season.name)
        matches.each do |match_params|
          match = CreateMatch::EntryPoint.call(season:, params: odds_portal_match_params_mapping(match_params))
          puts "#{match.home_team} - #{match.away_team} match has been added"
        end
      end

      def odds_portal_match_params_mapping(match_params)
        home_team, away_team = match_params.fetch(:participants).split(' - ')
        {
          home_team:,
          away_team:,
          score: match_params.fetch(:score),
          date: match_params.fetch(:match_date),
          time: match_params.fetch(:match_time),
          betting_odds: {
            home_team_win: match_params.dig(:odds, :home_win),
            away_team_win: match_params.dig(:odds, :away_win),
            draw: match_params.dig(:odds, :draw)
          }
        }
      end

    end
  end
end

Tasks::Seasons::FetchAllMatches.new
