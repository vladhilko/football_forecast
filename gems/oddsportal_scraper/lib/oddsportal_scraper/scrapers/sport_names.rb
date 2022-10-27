# frozen_string_literal: true

require 'wombat'

module OddsportalScraper
  module Scrapers
    class SportNames

      def self.call
        new.call
      end

      def call
        parse.fetch('sport_names')
      end

      private

      def parse
        Wombat.crawl do
          base_url 'https://oddsportal.com'
          path '/'

          sport_names({ css: '.sport_name a' }, :list)
        end
      end

    end
  end
end
