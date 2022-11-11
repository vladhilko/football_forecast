# frozen_string_literal: true

module Seasons
  module CompleteMatchesPopulation
    class EntryPoint < BaseEntryPoint

      def initialize(season:)
        @action = Action.new(season:)
      end

    end
  end
end
