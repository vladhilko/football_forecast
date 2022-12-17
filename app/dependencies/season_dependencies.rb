# frozen_string_literal: true

class SeasonContainer

  extend Dry::Container::Mixin

  register 'complete_matches_population' do
    ::Seasons::CompleteMatchesPopulation::EntryPoint
  end

end

SeasonDependencies = Dry::AutoInject SeasonContainer
