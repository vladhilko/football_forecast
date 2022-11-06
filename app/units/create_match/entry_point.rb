# frozen_string_literal: true

module CreateMatch
  class EntryPoint

    def initialize(season:, params:)
      form = CreateMatch::Form.new(params)
      @action = CreateMatch::Action.new(season:, form:)
    end

    delegate :call, to: :action

    private

    attr_reader :action

  end
end
