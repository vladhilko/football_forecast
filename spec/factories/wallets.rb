# frozen_string_literal: true

FactoryBot.define do
  factory :wallet do
    association :user
    currency { 'PLAY' }
    balance_minor { 1_000_000 }
  end
end
