# frozen_string_literal: true

module Countries
  module PopulateMatches
    class EntryPoint < BaseEntryPoint

      def initialize(country:)
        @action = Action.new(country:)
      end

    end
  end
end
