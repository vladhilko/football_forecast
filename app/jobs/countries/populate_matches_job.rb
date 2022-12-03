# frozen_string_literal: true

module Countries
  class PopulateMatchesJob

    include Sidekiq::Job

    def perform(country_id)
      country = Queries::Country.find(country_id)

      ::Countries::PopulateMatches::EntryPoint.call(country:)
    end

  end
end
