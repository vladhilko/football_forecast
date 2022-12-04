# frozen_string_literal: true

module Seasons
  class PopulateMatchesJob

    include Sidekiq::Job

    def perform(season_id)
      season = Queries::Season.find(season_id)

      ::Seasons::PopulateMatches::EntryPoint.call(season:)
    end

  end
end
