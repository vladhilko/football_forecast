# frozen_string_literal: true

module Queries
  class Match < Query

    set_model ::Match

    module Scopes
      def by_season(season)
        where(season:)
      end

      def by_season_and_team(season, team)
        by_season(season).where(away_team: team).or(
          by_season(season).where(home_team: team)
        )
      end

      # TODO: Move to the Decorator Collection object
      def uniq_teams
        flat_map { [_1.home_team, _1.away_team] }.uniq.sort
      end
    end

  end
end
