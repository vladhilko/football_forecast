# frozen_string_literal: true

FactoryBot.define do
  factory :betting_odds do
    home_team_win { 2.45 }
    away_team_win { 2.67 }
    draw { 3.01 }

    association :match
  end
end
