# frozen_string_literal: true

FactoryBot.define do
  factory :league do
    name { Faker::Sports::Football.unique.competition }
    association :country
  end
end
