# frozen_string_literal: true

module Betting
  module PlaceBet
    class Struct < Dry::Struct

      attribute :bet_amount, Types::Coercible::Decimal
      attribute :team, Types::String
      attribute :bet_type, Types::String

    end
  end
end
