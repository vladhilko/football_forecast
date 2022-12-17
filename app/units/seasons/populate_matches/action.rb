# frozen_string_literal: true

module Seasons
  module PopulateMatches
    class Action

      include SeasonDependencies['complete_matches_population']
      include MatchDependencies['create_match']

      def initialize(season:, **deps)
        super(**deps)

        @season = season
        @league = season.league
        @country = league.country
      end

      def call
        not_cancelled_matches.lazy.each do |match_params|
          mapped_params = oddsportal_match_params_mapping(match_params)

          create_match.call(season:, params: mapped_params) unless match_present?(mapped_params)
        end

        complete_matches_population.call(season:)
      end

      private

      attr_reader :season, :league, :country

      def not_cancelled_matches
        fetched_matches.reject { _1.fetch(:score) == Constants.match.result_types.cancelled }
      end

      def fetched_matches
        OddsportalScraper.matches(sport: 'soccer', country: country.name, league: league.name, season: season.name)
      end

      def oddsportal_match_params_mapping(match_params)
        ParamsMappers::OddsportalMatch.call(params: match_params)
      end

      def match_present?(params)
        Match.exists?(
          home_team: params[:home_team],
          away_team: params[:away_team],
          date: params[:date],
          season:
        )
      end

    end
  end
end
