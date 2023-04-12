# frozen_string_literal: true

FactoryBot.define do
  factory :bet do
    bet_amount { 100 }
    payout_amount { 0 }
    odds { 1.5 }
    team { 'Arsenal' }
    bet_type { 'home_team_win' }
    status { 'pending' }
    result { nil }

    association :match
  end
end
