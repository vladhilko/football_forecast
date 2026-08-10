# frozen_string_literal: true

FactoryBot.define do
  factory :time_travel_session_match do
    association :time_travel_session
    association :source_match, factory: :match
    sequence(:position)
    home_team { source_match.home_team }
    away_team { source_match.away_team }
    kickoff_at { Time.zone.local(2021, 12, 4, 15) }
    kickoff_timezone { 'Europe/London' }
    home_odds { 2.1 }
    draw_odds { 3.2 }
    away_odds { 3.4 }
    final_home_score { 2 }
    final_away_score { 1 }
    synthetic_events { [{ minute: 21, side: 'home' }, { minute: 64, side: 'away' }, { minute: 83, side: 'home' }] }
  end
end
