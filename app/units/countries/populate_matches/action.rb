# frozen_string_literal: true

module Countries
  module PopulateMatches
    class Action

      def initialize(country:)
        @country = country
      end

      def call
        country_leagues.each do |league|
          Leagues::PopulateMatchesJob.perform_async(league.id)
        end
      end

      private

      attr_reader :country

      def country_leagues
        Queries::League.by_country(country)
      end

    end
  end
end
