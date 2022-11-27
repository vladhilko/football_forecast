# frozen_string_literal: true

module Leagues
  class PopulateMatchesJob

    include Sidekiq::Job

    def perform(league_id)
      league = Queries::League.find(league_id)

      ::Leagues::PopulateMatches::EntryPoint.call(league:)
    end

  end
end
