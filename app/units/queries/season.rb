# frozen_string_literal: true

module Queries
  class Season

    class << self

      def by_league(league)
        ::Season.where(league:)
      end

    end

  end
end
