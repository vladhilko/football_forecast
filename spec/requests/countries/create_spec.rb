# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Creating Countries' do
  subject(:send_request) { post request_uri }

  let(:request_uri) { '/api/countries' }

  it 'creates a country and returns it' do
    send_request

    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)).to eq({ 'id' => 1, 'name' => 'Spain' })
  end
end
