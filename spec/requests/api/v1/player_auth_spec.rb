# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Player authentication API' do
  it 'registers and returns the signed-in player with play credits' do
    post '/api/v1/users', params: {
      user: {
        display_name: 'Ada', email: 'ada@example.com', password: 'password123', password_confirmation: 'password123'
      }
    }

    expect(response).to have_http_status(:created)
    expect(response.parsed_body).to include(
      'user' => include('display_name' => 'Ada', 'email' => 'ada@example.com'),
      'wallet' => include('currency' => 'PLAY', 'balance_minor' => 1_000_000)
    )

    get '/api/v1/me'
    expect(response).to have_http_status(:ok)
  end
end
