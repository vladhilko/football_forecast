# frozen_string_literal: true

require 'rails_helper'

describe Admin::CalculateSeasonProfitController, type: :controller do
  render_views

  before do
    freeze_time
    sign_in create(:admin_user)
  end

  let(:england) { create(:country, name: 'England') }
  let(:premier_league) { create(:league, country: england, name: 'Premier League') }
  let(:season_2008_2009) { create(:season, league: premier_league, name: '2008/2009', populated_at: Time.current) }

  describe 'POST #calculate_season_profit' do
    before do
      season_2008_2009

      create(:match, season: season_2008_2009)
      create(:match, season: season_2008_2009)
    end

    it 'calls Seasons::CalculateProfit::EntryPoint unit' do
      expect(Seasons::CalculateProfit::EntryPoint).to receive(:call).with(
        season: season_2008_2009,
        params: {
          team: 'Arsenal',
          amount: '100',
          bet_strategy: 'always_win'
        }
      )

      post(:calculate_season_profit, params: {
             season_id: season_2008_2009.id, calculate_season_profit: { team: 'Arsenal', amount: 100,
                                                                        bet_strategy: 'always_win' }
           })

      expect(response).to have_http_status(:redirect)
    end
  end
end
