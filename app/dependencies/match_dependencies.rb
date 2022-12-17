# frozen_string_literal: true

class MatchContainer

  extend Dry::Container::Mixin

  register 'create_match' do
    ::CreateMatch::EntryPoint
  end

end

MatchDependencies = Dry::AutoInject MatchContainer
