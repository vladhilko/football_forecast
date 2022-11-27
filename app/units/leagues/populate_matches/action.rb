# frozen_string_literal: true

module Leagues
  module PopulateMatches
    class Action

      def initialize(league:, season_status:)
        @league = league
        @season_status = season_status
      end

      def call
        league_seasons.each do |season|
          Seasons::PopulateMatches::EntryPoint.call(season:)
        end
      end

      private

      attr_reader :league, :season_status

      def league_seasons
        Queries::Season.by_league_and_status(league, season_status)
      end

    end
  end
end
