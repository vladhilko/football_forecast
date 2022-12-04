# frozen_string_literal: true

require 'rails_helper'

describe Admin::CountriesController, type: :controller do
  render_views

  before { sign_in create(:admin_user) }

  let(:spain) { create(:country, name: 'Spain') }
  let(:england) { create(:country, name: 'England') }

  describe 'GET #index' do
    before do
      spain
      england
    end

    it 'renders countries' do
      get :index

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(
        spain.id.to_s,
        spain.name,
        england.id.to_s,
        england.name
      )
    end
  end

  describe 'GET #show' do
    before do
      england
      premier_league
    end

    let(:premier_league) { create(:league, country: england, name: 'Premier League') }

    it 'renders country' do
      get(:show, params: { id: england.id })

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(
        england.id.to_s,
        england.name,
        england.created_at.strftime('%B %d, %Y %H:%M'),
        england.updated_at.strftime('%B %d, %Y %H:%M'),
        premier_league.name
      )
    end
  end

  describe 'POST #populate_matches' do
    let(:premier_league) { create(:league, country: england, name: 'Premier League') }
    let(:championship) { create(:league, country: england, name: 'championship') }

    before do
      premier_league
      championship
    end

    it 'calls Countries::PopulateMatches unit' do
      expect(Countries::PopulateMatchesJob).to receive(:perform_async).with(england.id)

      post(:populate_matches, params: { id: england.id })

      expect(response).to have_http_status(:redirect)
    end
  end
end
