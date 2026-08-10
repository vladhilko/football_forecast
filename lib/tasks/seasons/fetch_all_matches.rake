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

            report = ActiveRecord::Base.transaction { populate_matches }

            season_matches_count_after_running_task = season.matches.count - initial_season_matches_count

            puts import_summary(report, season_matches_count_after_running_task)
          end
        end
      end

      private

      attr_reader :country, :league, :season

      def populate_matches
        ::Seasons::PopulateMatches::EntryPoint.call(season:)
      end

      def import_summary(report, added_count)
        return "#{added_count} matches have been added to the DB" unless report.is_a?(Hash)

        if report[:fetched_count].zero?
          return '0 matches have been added to the DB; ' \
            'OddsPortal returned no matches with available odds'
        end

        details = "(#{report[:cancelled_count]} cancelled, " \
          "#{report[:skipped_count]} skipped because required odds were missing)"
        "#{added_count} matches have been added to the DB #{details}"
      end

    end
  end
end

Tasks::Seasons::FetchAllMatches.new
