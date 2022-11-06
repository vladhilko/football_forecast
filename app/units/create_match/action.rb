# frozen_string_literal: true

module CreateMatch
  class Action

    def initialize(season:, inputs:)
      @inputs = inputs
      @season = season
    end

    def call
      Command.save match
    end

    attr_reader :inputs, :season

    def match
      Match.new(inputs.attributes.merge(season_id: season.id))
    end

  end
end
