# frozen_string_literal: true

module CreateMatch
  class EntryPoint

    def initialize(season:, params:)
      @action = CreateMatch::Action.new(season:, params:)
    end

    delegate :call, to: :action

    private

    attr_reader :action

  end
end
