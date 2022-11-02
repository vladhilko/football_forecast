# frozen_string_literal: true

module Tasks
  module Leagues
    class Fetch

      include Rake::DSL

      def initialize
        namespace :leagues do
          desc 'Fetches all leagues from all countries from oddsportal and saves them to the database'
          task fetch_all: [:environment] do
            initial_leagues_count = League.count

            Country.all.each { create_all_leagues_for(country: _1) }

            leagues_count_after_running_task = League.count - initial_leagues_count

            puts "#{leagues_count_after_running_task} leagues have been added to the DB"
          end
        end
      end

      private

      def create_all_leagues_for(country:)
        puts "Adding #{country.name} leagues"

        leagues = OddsportalScraper.leagues(sport: 'soccer', country: country.name)
        leagues.each do |league|
          League.create(name: league, country:) unless League.exists?(name: league, country:)
        end
      end

    end
  end
end

Tasks::Leagues::Fetch.new
