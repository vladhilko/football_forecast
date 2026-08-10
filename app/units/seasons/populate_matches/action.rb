# frozen_string_literal: true

module Seasons
  module PopulateMatches
    class Action

      include SeasonDependencies['complete_matches_population']
      include MatchDependencies['create_match']

      def initialize(season:, **deps)
        super(**deps)

        @season = season
        @league = season.league
        @country = league.country
      end

      def call
        fetched = fetched_matches
        cancelled, not_cancelled = fetched.partition { _1.fetch(:score) == Constants.match.result_types.cancelled }
        matches, skipped_count = persistable_matches(not_cancelled)
        persisted_count = persist_matches(matches)

        complete_matches_population.call(season:)

        import_report(fetched:, cancelled:, skipped_count:, persisted_count:)
      end

      private

      attr_reader :season, :league, :country

      def persistable_matches(matches)
        skipped_count = matches.count { |match_params| missing_required_odds?(match_params) }
        log_skipped_matches(skipped_count)
        [matches.reject { |match_params| missing_required_odds?(match_params) }, skipped_count]
      end

      def log_skipped_matches(count)
        return unless count.positive?

        Rails.logger.info(
          "#{count} matches skipped because OddsPortal did not provide all required odds " \
          "for #{country.name} #{league.name} #{season.name}"
        )
      end

      def persist_matches(matches)
        matches.count do |match_params|
          mapped_params = oddsportal_match_params_mapping(match_params)
          next false if match_present?(mapped_params)

          create_match.call(season:, params: mapped_params)
          true
        end
      end

      def import_report(fetched:, cancelled:, skipped_count:, persisted_count:)
        {
          fetched_count: fetched.size,
          cancelled_count: cancelled.size,
          skipped_count:,
          persisted_count:,
          completeness_status: season.completeness_status
        }
      end

      def missing_required_odds?(match_params)
        odds = match_params.fetch(:odds, {})
        %i[home_win draw away_win].any? { |key| odds[key].nil? || odds[key].to_s.strip.empty? }
      end

      def fetched_matches
        OddsportalScraper.matches(sport: 'soccer', country: country.name, league: league.name, season: season.name)
      end

      def oddsportal_match_params_mapping(match_params)
        ParamsMappers::OddsportalMatch.call(params: match_params)
      end

      def match_present?(params)
        Match.exists?(
          home_team: params[:home_team],
          away_team: params[:away_team],
          date: params[:date],
          season:
        )
      end

    end
  end
end
