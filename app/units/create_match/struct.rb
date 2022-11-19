# frozen_string_literal: true

module CreateMatch
  class Struct < Dry::Struct

    attribute :home_team, Types::String
    attribute :away_team, Types::String
    attribute :score, Types::String
    attribute :date, Types::String
    attribute :time, Types::String

    attribute :betting_odds do
      attribute :home_team_win, Types::BettingCoefficient
      attribute :away_team_win, Types::BettingCoefficient
      attribute :draw, Types::BettingCoefficient
    end

  end
end
