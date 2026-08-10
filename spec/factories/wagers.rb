# frozen_string_literal: true

FactoryBot.define do
  factory :wager do
    association :user
    association :time_travel_session
    association :time_travel_session_match
    source_match { time_travel_session_match.source_match }
    placement_key { SecureRandom.uuid }
    selection { 'home' }
    stake_minor { 10_000 }
    decimal_odds { 2.1 }
    potential_payout_minor { 21_000 }
    payout_minor { 0 }
    status { 'pending' }
    placed_at { Time.current }

    before(:validation) do |wager|
      wager.user = wager.time_travel_session.user
    end
  end
end
