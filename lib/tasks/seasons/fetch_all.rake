# frozen_string_literal: true

module Tasks
  module Seasons
    class Fetch

      include Rake::DSL

      def initialize
        namespace :seasons do
          desc 'Fetches all available football seasons to the database'
          task fetch_all: [:environment] do
            initial_seasons_count = Season.count

            League.all.each { create_all_seasons_for(league: _1) }

            seasons_count_after_running_task = Season.count - initial_seasons_count

            puts "#{seasons_count_after_running_task} seasons have been added to the DB"
          end
        end
      end

      private

      def create_all_seasons_for(league:)
        country = league.country.name

        puts "Adding #{country} #{league.name} seasons:"

        seasons = OddsportalScraper.seasons(sport: 'soccer', country:, league: league.name)
        seasons.each do |season|
          Season.create(name: season, league:).tap { puts _1.name } unless Season.exists?(name: season, league:)
        end
      end

    end
  end
end

Tasks::Seasons::Fetch.new
