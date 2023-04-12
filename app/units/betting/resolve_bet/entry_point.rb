# frozen_string_literal: true

module Betting
  module ResolveBet
    class EntryPoint < BaseEntryPoint

      def initialize(bet)
        @action = Action.new(bet)
      end

    end
  end
end
