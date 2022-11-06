# frozen_string_literal: true

module CreateMatch
  class EntryPoint < BaseEntryPoint

    def initialize(season:, params:)
      @inputs = CreateMatch::Inputs.new(params:)
      @action = CreateMatch::Action.new(season:, inputs:)
    end

  end
end
