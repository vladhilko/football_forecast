# frozen_string_literal: true

module Queries
  class Match < Query

    set_model ::Match

    module Scopes
      def by_season(season)
        where(season:)
      end
    end

  end
end
