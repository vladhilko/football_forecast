# frozen_string_literal: true

module CreateMatch
  class Inputs < ::Inputs

    params do
      required(:home_team).filled(:string)
      required(:away_team).filled(:string)
      required(:score).filled(:string)
      required(:date).filled(:date)
      optional(:time).filled(:string)
    end

  end
end
