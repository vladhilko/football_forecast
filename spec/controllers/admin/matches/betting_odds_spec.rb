# frozen_string_literal: true

require 'rails_helper'

describe Admin::BettingOddsController, type: :controller do
  render_views

  before { sign_in create(:admin_user) }

  let(:england) { create(:country, name: 'England') }
  let(:premier_league) { create(:league, country: england, name: 'Premier League') }
  let(:season_2008_2009) { create(:season, league: premier_league, name: '2008/2009') }

  let(:match_1) { create(:match, season: season_2008_2009) }
  let(:match_2) { create(:match, home_team: 'Brentford', away_team: 'Fulham', season: season_2008_2009) }

  let(:betting_odds_match_1) { create(:betting_odds, match: match_1) }
  let(:betting_odds_match_2) { create(:betting_odds, match: match_2) }

  describe 'GET #index' do
    before do
      betting_odds_match_1
      betting_odds_match_2
    end

    it 'renders betting odds' do
      get :index

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(
        betting_odds_match_1.id.to_s,
        betting_odds_match_1.home_team_win.to_s,
        betting_odds_match_1.draw.to_s,
        betting_odds_match_1.away_team_win.to_s,
        match_1.name,
        betting_odds_match_2.id.to_s,
        betting_odds_match_2.home_team_win.to_s,
        betting_odds_match_2.draw.to_s,
        betting_odds_match_2.away_team_win.to_s,
        match_2.name
      )
    end
  end

  describe 'GET #show' do
    before { betting_odds_match_1 }

    it 'renders the given betting odds' do
      get(:show, params: { id: betting_odds_match_1.id })

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(
        betting_odds_match_1.id.to_s,
        betting_odds_match_1.home_team_win.to_s,
        betting_odds_match_1.draw.to_s,
        betting_odds_match_1.away_team_win.to_s,
        betting_odds_match_1.created_at.strftime('%B %d, %Y %H:%M'),
        betting_odds_match_1.updated_at.strftime('%B %d, %Y %H:%M'),
        match_1.name
      )
    end
  end
end
