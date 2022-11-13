# frozen_string_literal: true

module ParamsMappers
  class OddsportalMatch

    def self.call(params:)
      new(params:).call
    end

    def initialize(params:)
      @params = params
      @home_team, @away_team = params.fetch(:participants).split(' - ')
    end

    def call
      {
        home_team:,
        away_team:,
        score: params.fetch(:score),
        date: params.fetch(:match_date),
        time: params.fetch(:match_time),
        betting_odds:
      }
    end

    private

    attr_reader :params, :home_team, :away_team

    def betting_odds
      {
        home_team_win: params.dig(:odds, :home_win),
        away_team_win: params.dig(:odds, :away_win),
        draw: params.dig(:odds, :draw)
      }
    end

  end
end
