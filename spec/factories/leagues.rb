# frozen_string_literal: true

FactoryBot.define do
  factory :league do
    name { 'Premier League' }
    association :country
  end
end
