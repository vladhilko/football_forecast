# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { "player#{_1}@example.com" }
    sequence(:display_name) { "Player #{_1}" }
    password { 'correct-horse-battery-staple' }
    preferred_reveal_mode { 'honest' }

    after(:create) do |user|
      create(:wallet, user:) unless user.wallet
    end
  end
end
