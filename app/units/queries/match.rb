# frozen_string_literal: true

module Queries
  class Match

    class << self

      def by_season(season)
        ::Match.where(season:)
      end

    end

  end
end
