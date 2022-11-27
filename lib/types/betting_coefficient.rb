# frozen_string_literal: true

module Types
  BettingCoefficient = Types::String.constructor { _1 || '1' }
end
