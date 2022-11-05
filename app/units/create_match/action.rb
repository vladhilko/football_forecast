# frozen_string_literal: true

module CreateMatch
  class Action

    def initialize(season:, params:)
      @params = params
      @season = season
    end

    def call
      Match.create(season:, **params)
    end

    attr_reader :params, :season

  end
end
