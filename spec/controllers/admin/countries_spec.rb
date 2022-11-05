# frozen_string_literal: true

require 'rails_helper'

describe Admin::CountriesController, type: :controller do
  render_views

  before { sign_in create(:admin_user) }

  describe 'GET #index' do
    let(:country1) { create(:country, name: 'Spain') }
    let(:country2) { create(:country, name: 'England') }

    before do
      country1
      country2
    end

    it 'renders countries' do
      get :index

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(
        country1.id.to_s,
        country1.name,
        country2.id.to_s,
        country2.name
      )
    end
  end

  describe 'GET #show' do
    let(:country) { create(:country, name: 'Spain') }

    it 'renders country' do
      get(:show, params: { id: country.id })

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(
        country.id.to_s,
        country.name,
        country.created_at.strftime('%B %d, %Y %H:%M'),
        country.updated_at.strftime('%B %d, %Y %H:%M')
      )
    end
  end
end
