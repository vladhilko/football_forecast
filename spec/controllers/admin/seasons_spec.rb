# frozen_string_literal: true

require 'rails_helper'

describe Admin::SeasonsController, type: :controller do
  render_views

  before { sign_in create(:admin_user) }

  let(:spain) { create(:country, name: 'Spain') }
  let(:england) { create(:country, name: 'England') }

  let(:premier_league) { create(:league, country: england, name: 'Premier League') }
  let(:laliga) { create(:league, country: spain, name: 'LaLiga') }

  let(:season_2008_2009) { create(:season, league: premier_league, name: '2008/2009') }
  let(:season_2009_2010) { create(:season, league: laliga, name: '2009/2010') }

  describe 'GET #index' do
    before do
      season_2008_2009
      season_2009_2010
    end

    it 'renders seasons' do
      get :index

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(
        season_2008_2009.id.to_s,
        season_2008_2009.name,
        premier_league.name,
        england.name,
        season_2009_2010.id.to_s,
        season_2009_2010.name,
        laliga.name,
        spain.name
      )
    end
  end

  describe 'GET #show' do
    before { season_2008_2009 }

    it 'renders season' do
      get(:show, params: { id: season_2008_2009.id })

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(
        season_2008_2009.id.to_s,
        season_2008_2009.name,
        premier_league.name,
        england.name,
        season_2008_2009.created_at.strftime('%B %d, %Y %H:%M'),
        season_2008_2009.updated_at.strftime('%B %d, %Y %H:%M')
      )
    end
  end
end
