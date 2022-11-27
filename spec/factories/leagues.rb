# frozen_string_literal: true

FactoryBot.define do
  factory :league do
    name { Faker::Sports::Football.competition }
    association :country
  end
end
