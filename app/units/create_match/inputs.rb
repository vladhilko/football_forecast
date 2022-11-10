# frozen_string_literal: true

module CreateMatch
  class Inputs < ::Inputs

    params do
      required(:home_team).filled(:string)
      required(:away_team).filled(:string)
      required(:score).filled(:string)
      required(:date).filled(:date)
      optional(:time).maybe(:string)
      required(:betting_odds).schema do
        required(:home_team_win).filled(:decimal)
        required(:away_team_win).filled(:decimal)
        required(:draw).filled(:decimal)
      end
    end

  end
end