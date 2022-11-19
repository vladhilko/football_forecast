# frozen_string_literal: true

require 'rails_helper'

describe Admin::MatchesController, type: :controller do
  render_views

  before { sign_in create(:admin_user) }

  let(:england) { create(:country, name: 'England') }
  let(:premier_league) { create(:league, country: england, name: 'Premier League') }
  let(:season_2008_2009) { create(:season, league: premier_league, name: '2008/2009') }

  let(:match_1) { create(:match, season: season_2008_2009) }
  let(:match_2) { create(:match, home_team: 'Brentford', away_team: 'Fulham', season: season_2008_2009) }

  describe 'GET #index' do
    before do
      match_1
      match_2
    end

    it 'renders matches' do
      get :index

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(
        match_1.id.to_s,
        match_1.home_team,
        match_1.away_team,
        match_1.score,
        match_1.date.strftime('%B %d, %Y'),
        match_1.time.strftime('%H:%M'),
        match_2.id.to_s,
        match_2.home_team,
        match_2.away_team,
        match_2.score,
        match_2.date.strftime('%B %d, %Y'),
        match_2.time.strftime('%H:%M'),
        season_2008_2009.name,
        premier_league.name
      )
    end
  end

  describe 'GET #show' do
    let(:match_1_betting_odds) { create(:betting_odds, match: match_1) }

    before do
      match_1
      match_1_betting_odds
    end

    it 'renders the given match' do
      get(:show, params: { id: match_1.id })

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(
        match_1.id.to_s,
        match_1.home_team,
        match_1.away_team,
        match_1.score,
        match_1.date.strftime('%B %d, %Y'),
        match_1.time.strftime('%H:%M'),
        match_1.created_at.strftime('%B %d, %Y %H:%M'),
        match_1.updated_at.strftime('%B %d, %Y %H:%M'),
        match_1_betting_odds.home_team_win.to_s,
        match_1_betting_odds.draw.to_s,
        match_1_betting_odds.away_team_win.to_s,
        season_2008_2009.name,
        premier_league.name
      )
    end
  end
end
