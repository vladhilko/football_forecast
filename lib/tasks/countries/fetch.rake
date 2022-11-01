# frozen_string_literal: true

module Tasks
  module Countries
    class Fetch

      include Rake::DSL

      def initialize
        namespace :countries do
          desc 'Fetches countries from oddsportal and saves them to the database'
          task fetch: [:environment] do
            countries = OddsportalScraper.countries(sport: 'soccer')
            countries.reject! { Country.exists?(name: _1) }
            countries.each { Country.create(name: _1) }

            puts "#{countries.size} countries have been added to the DB"
          end
        end
      end

    end
  end
end

Tasks::Countries::Fetch.new
