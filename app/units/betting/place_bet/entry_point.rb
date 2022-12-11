# frozen_string_literal: true

module Betting
  module PlaceBet
    class EntryPoint < BaseEntryPoint

      def initialize(match:, params:)
        @form = Form.new(params:)
        @action = Action.new(match:, form:)
      end

    end
  end
end
