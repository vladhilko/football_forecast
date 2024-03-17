# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Updating Countries' do
  subject(:send_request) { put request_uri }

  let(:request_uri) { '/api/countries' }

  it 'updates the country and returns nothing' do
    send_request

    expect(response).to have_http_status(:no_content)
    expect(response.body).to be_empty
  end
end