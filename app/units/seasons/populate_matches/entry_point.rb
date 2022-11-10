# frozen_string_literal: true

module Seasons
  module PopulateMatches
    class EntryPoint < BaseEntryPoint

      def initialize(season:)
        @action = Action.new(season:)
      end

    end
  end
end
