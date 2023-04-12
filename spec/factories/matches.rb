# frozen_string_literal: true

FactoryBot.define do
  factory :match do
    home_team { Faker::Sports::Football.team }
    away_team { Faker::Sports::Football.team }
    score { '2:1' }
    date { '01.12.2010' }
    time { '17:00' }

    association :season
  end
end
