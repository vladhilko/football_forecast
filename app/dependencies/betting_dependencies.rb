# frozen_string_literal: true

class BettingContainer

  extend Dry::Container::Mixin

  register 'place_bet' do
    ::Betting::PlaceBet::EntryPoint
  end

  register 'resolve_bet' do
    ::Betting::ResolveBet::EntryPoint
  end

end

BettingDependencies = Dry::AutoInject BettingContainer
