# frozen_string_literal: true

module Leagues
  module PopulateMatches
    class EntryPoint < BaseEntryPoint

      def initialize(league:, season_status: Constants.season.completeness_statuses.initial)
        @action = Action.new(league:, season_status:)
        @league = league
      end

    end
  end
end
