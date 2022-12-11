# frozen_string_literal: true

module CreateMatch
  class EntryPoint < BaseEntryPoint

    def initialize(season:, params:)
      @form = Form.new(params:)
      @action = Action.new(season:, form:)
    end

  end
end
