# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Listing Countries' do
  subject(:send_request) { get request_uri }

  let(:request_uri) { '/api/countries' }

  it 'lists all countries' do
    send_request

    expect(response).to have_http_status(:successful)
    expect(JSON.parse(response.body)).to eq([{ 'id' => 1, 'name' => 'Spain' }])
  end
end
