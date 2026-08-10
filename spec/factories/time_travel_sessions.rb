# frozen_string_literal: true

FactoryBot.define do
  factory :time_travel_session do
    association :user
    association :league
    travel_on { Date.new(2021, 12, 1) }
    round_fingerprint { SecureRandom.hex(32) }
    status { 'betting' }
    reveal_mode { 'honest' }
  end
end
