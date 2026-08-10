# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Time travel result secrecy API' do
  it 'never includes scores or outcomes while betting is open' do
    user = create(:user)
    session = create(:time_travel_session, user:)
    create(:time_travel_session_match, time_travel_session: session, final_home_score: 8, final_away_score: 0)
    sign_in user

    get "/api/v1/time_travel_sessions/#{session.uuid}"

    expect(response).to have_http_status(:ok)
    fixture = response.parsed_body.dig('session', 'fixtures', 0)
    expect(fixture).to include('home_team', 'away_team', 'odds')
    expect(fixture).not_to include('final_score', 'final_home_score', 'final_away_score', 'result')
  end

  it 'accepts permitted JSON wager selections and debits the wallet once' do
    user = create(:user)
    session = create(:time_travel_session, user:)
    fixture = create(:time_travel_session_match, time_travel_session: session, home_odds: 2.5)
    sign_in user

    post "/api/v1/time_travel_sessions/#{session.uuid}/wagers",
         params: {
           selections: [{ fixture_id: fixture.uuid, selection: 'home', stake_minor: 10_000 }]
         },
         headers: { 'Idempotency-Key' => SecureRandom.uuid },
         as: :json

    expect(response).to have_http_status(:created)
    expect(response.parsed_body).to include(
      'wallet' => include('balance_minor' => 990_000),
      'wagers' => [include('selection' => 'home', 'stake_minor' => 10_000)]
    )
  end
end
