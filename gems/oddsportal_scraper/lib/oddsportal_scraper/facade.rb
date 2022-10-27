# frozen_string_literal: true

module OddsportalScraper
  class Facade

    class << self

      def sport_names
        Scrapers::SportNames.call
      end

    end

  end
end
