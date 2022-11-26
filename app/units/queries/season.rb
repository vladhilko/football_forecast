# frozen_string_literal: true

module Queries
  class Season

    class << self

      def by_league(league)
        ::Season.where(league:)
      end

      def by_league_and_status(league, status)
        ::Season.where(league:, completeness_status: status)
      end

      def by_completeness_status(completeness_status)
        ::Season.where(completeness_status:)
      end

    end

  end
end
