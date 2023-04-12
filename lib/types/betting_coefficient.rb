# frozen_string_literal: true

module Types
  BettingCoefficient = Dry::Types['coercible.decimal'].constructor do |input, type|
    type.(input) { 1 }
  end
end
