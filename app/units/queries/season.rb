# frozen_string_literal: true

module Queries
  class Season < Query

    set_model ::Season

    module Scopes
      def by_league(league)
        where(league:)
      end

      def by_league_and_status(league, status)
        by_league(league).by_completeness_status(status)
      end

      def by_completeness_status(completeness_status)
        where(completeness_status:)
      end
    end

  end
end
