# frozen_string_literal: true

module Betting
  module PlaceBet
    class EntryPoint < BaseEntryPoint

      def initialize(match:, params:)
        @inputs = Inputs.new(params: Struct.new(params).to_h)
        @action = Action.new(match:, inputs:)
      end

    end
  end
end
