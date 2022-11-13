# frozen_string_literal: true

module CreateMatch
  class EntryPoint < BaseEntryPoint

    def initialize(season:, params:)
      @inputs = Inputs.new(params:)
      @action = Action.new(season:, inputs:)
    end

  end
end
