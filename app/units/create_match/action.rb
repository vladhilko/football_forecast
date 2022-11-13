# frozen_string_literal: true

module CreateMatch
  class Action

    def initialize(season:, inputs:)
      @inputs = inputs
      @season = season
    end

    def call
      Command.save(match).tap do |created_match|
        Subactions::CreateBettingOdds.new(match: created_match, params: betting_odds_attributes).call
      end
    end

    private

    attr_reader :inputs, :season

    def match
      Match.new(match_attributes)
    end

    def match_attributes
      inputs.attributes.except(:betting_odds).merge(season_id: season.id)
    end

    def betting_odds_attributes
      inputs.attributes.fetch(:betting_odds)
    end

  end
end
