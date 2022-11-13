# frozen_string_literal: true

module Seasons
  module CompleteMatchesPopulation
    class Action

      def initialize(season:)
        @season = season
      end

      def call
        season.completeness_status = completeness_status
        season.populated_at = Time.current

        Command.save season
      end

      private

      attr_reader :season

      def season_matches
        @season_matches ||= Queries::Match.by_season(season)
      end

      def completeness_status
        case season_matches.size
        when 0 then Constants.season.completeness_statuses.empty
        when (required_season_games_count...) then Constants.season.completeness_statuses.full
        when (1...required_season_games_count) then Constants.season.completeness_statuses.partial
        end
      end

      def league_teams_count
        @league_teams_count ||= season_matches.pluck(:home_team, :away_team).flatten.uniq.count
      end

      def required_season_games_count
        (league_teams_count - 1) * league_teams_count
      end

    end
  end
end
