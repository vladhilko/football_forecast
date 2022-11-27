# frozen_string_literal: true

require 'rails_helper'

describe Admin::LeaguesController, type: :controller do
  render_views

  before { sign_in create(:admin_user) }

  let(:spain) { create(:country, name: 'Spain') }
  let(:england) { create(:country, name: 'England') }

  let(:premier_league) { create(:league, country: england, name: 'Premier League') }
  let(:laliga) { create(:league, country: spain, name: 'LaLiga') }

  describe 'GET #index' do
    before do
      premier_league
      laliga
    end

    it 'renders leagues' do
      get :index

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(
        premier_league.id.to_s,
        premier_league.name,
        england.name,
        laliga.id.to_s,
        laliga.name,
        spain.name
      )
    end
  end

  describe 'GET #show' do
    before do
      premier_league
      season_2008_2009
    end

    let(:season_2008_2009) { create(:season, league: premier_league, name: '2008/2009') }

    it 'renders league' do
      get(:show, params: { id: premier_league.id })

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(
        premier_league.id.to_s,
        premier_league.name,
        premier_league.created_at.strftime('%B %d, %Y %H:%M'),
        premier_league.updated_at.strftime('%B %d, %Y %H:%M'),
        england.name,
        season_2008_2009.name,
        season_2008_2009.completeness_status,
        'Populate All Initial Seasons'
      )
    end
  end

  describe 'POST #populate_matches' do
    let(:season_2008_2009) { create(:season, league: premier_league, name: '2008/2009') }
    let(:season_2009_2010) { create(:season, league: premier_league, name: '2009/2010') }

    before do
      season_2008_2009
      season_2009_2010
    end

    it 'calls Leagues::PopulateMatches unit' do
      expect(Leagues::PopulateMatches::EntryPoint).to receive(:call).with(league: premier_league)

      post(:populate_matches, params: { id: premier_league.id })

      expect(response).to have_http_status(:redirect)
    end
  end
end
