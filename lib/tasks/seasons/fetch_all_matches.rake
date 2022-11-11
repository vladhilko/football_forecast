# frozen_string_literal: true

module Tasks
  module Seasons
    class FetchAllMatches

      include Rake::DSL

      def initialize
        namespace :seasons do
          desc 'Fetches all available football matches from the given season to the database'
          task :fetch_all_matches, %i[country league season] => :environment do |_, args|
            @country = Country.find_by(name: args.fetch(:country))
            @league = League.find_by(name: args.fetch(:league), country:)
            @season = Season.find_by(name: args.fetch(:season), league:)

            raise Errors::SeasonNotFound, 'Please check provided params' if season.blank?

            initial_season_matches_count = season.matches.count

            puts "Start creating matches for #{country.name} #{league.name} #{season.name}:"

            ActiveRecord::Base.transaction { populate_matches }

            season_matches_count_after_running_task = season.matches.count - initial_season_matches_count

            puts "#{season_matches_count_after_running_task} matches have been added to the DB"
          end
        end
      end

      private

      attr_reader :country, :league, :season

      def populate_matches
        ::Seasons::PopulateMatches::EntryPoint.call(season:)
      end

    end
  end
end

Tasks::Seasons::FetchAllMatches.new
