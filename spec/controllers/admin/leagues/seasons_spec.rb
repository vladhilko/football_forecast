# frozen_string_literal: true

require 'rails_helper'

describe Admin::SeasonsController, type: :controller do
  render_views

  before do
    freeze_time
    sign_in create(:admin_user)
  end

  let(:spain) { create(:country, name: 'Spain') }
  let(:england) { create(:country, name: 'England') }

  let(:premier_league) { create(:league, country: england, name: 'Premier League') }
  let(:laliga) { create(:league, country: spain, name: 'LaLiga') }

  let(:season_2008_2009) { create(:season, league: premier_league, name: '2008/2009', populated_at: Time.current) }
  let(:season_2009_2010) { create(:season, league: laliga, name: '2009/2010', populated_at: Time.current) }

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
        season_2008_2009.completeness_status,
        premier_league.name,
        england.name,
        season_2009_2010.id.to_s,
        season_2009_2010.name,
        season_2009_2010.completeness_status,
        laliga.name,
        spain.name
      )
    end
  end

  describe 'GET #show' do
    before do
      season_2008_2009

      create(:match, season: season_2008_2009)
      create(:match, season: season_2008_2009)
    end

    it 'renders season' do
      get(:show, params: { id: season_2008_2009.id })

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(
        season_2008_2009.id.to_s,
        season_2008_2009.name,
        season_2008_2009.completeness_status,
        season_2008_2009.populated_at.strftime('%B %d, %Y %H:%M'),
        premier_league.name,
        england.name,
        season_2008_2009.created_at.strftime('%B %d, %Y %H:%M'),
        season_2008_2009.updated_at.strftime('%B %d, %Y %H:%M'),
        'Populate Matches',
        'Calculate Season Profit',
        admin_matches_path
      )
    end
  end

  describe 'POST #populate_matches' do
    before { season_2008_2009 }

    it 'calls Seasons::PopulateMatches unit' do
      expect(Seasons::PopulateMatches::EntryPoint).to receive(:call).with(season: season_2008_2009)

      post(:populate_matches, params: { id: season_2008_2009.id })

      expect(response).to have_http_status(:redirect)
    end
  end
end
