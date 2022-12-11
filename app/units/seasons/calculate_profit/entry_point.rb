# frozen_string_literal: true

module Seasons
  module CalculateProfit
    class EntryPoint < BaseEntryPoint

      def initialize(season:, params:)
        @form = Form.new(params:)
        @action = Action.new(season:, params:)
      end

    end
  end
end
