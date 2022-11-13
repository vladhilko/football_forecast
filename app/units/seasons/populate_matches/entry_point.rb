# frozen_string_literal: true

module Seasons
  module PopulateMatches
    class EntryPoint < BaseEntryPoint

      authorize 'seasons/authorizers/not_populated'

      def initialize(season:)
        @action = Action.new(season:)
        @season = season
      end

      attr_reader :season

    end
  end
end
