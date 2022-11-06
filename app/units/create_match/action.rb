# frozen_string_literal: true

module CreateMatch
  class Action

    def initialize(season:, form:)
      @params = form.attributes

      @season = season
    end

    def call
      Match.create(season:, **params)
    end

    attr_reader :params, :season

  end
end
