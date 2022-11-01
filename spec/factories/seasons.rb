# frozen_string_literal: true

FactoryBot.define do
  factory :season do
    name { '2019/2020' }
    association :league
  end
end
