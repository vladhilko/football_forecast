# frozen_string_literal: true

FactoryBot.define do
  factory :season do
    name { '2019/2020' }
    completeness_status { 'initial' }
    association :league
  end
end
