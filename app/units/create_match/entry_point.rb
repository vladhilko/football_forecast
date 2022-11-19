# frozen_string_literal: true

module CreateMatch
  class EntryPoint < BaseEntryPoint

    def initialize(season:, params:)
      @inputs = Inputs.new(params: Struct.new(params).to_h)
      @action = Action.new(season:, inputs:)
    end

  end
end
