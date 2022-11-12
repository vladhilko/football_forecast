# frozen_string_literal: true

FactoryBot.define do
  factory :season do
    name { '2019/2020' }
    completeness_status { 'initial' }

    association :league

    trait :populated do
      completeness_status { 'full' }
      populated_at { '12.11.2022 12:00'.to_datetime }
    end
  end
end
