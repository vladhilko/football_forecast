# frozen_string_literal: true

require 'rails_helper'

describe Seasons::CalculateProfit::EntryPoint do
  subject { described_class.call(season:, params:) }

  let(:season) { create(:season, name: '2021/2022') }

  let(:match_1) { create(:match, season:, home_team: 'Arsenal', away_team: 'Liverpool', score: '2:1') }
  let(:match_2) { create(:match, season:, home_team: 'Liverpool', away_team: 'Arsenal', score: '5:1') }

  let(:betting_odds_match_1) do
    create(:betting_odds, match: match_1,
                          home_team_win: 2.45,
                          away_team_win: 2.67,
                          draw: 3.01)
  end
  let(:betting_odds_match_2) do
    create(:betting_odds, match: match_2,
                          home_team_win: 1.34,
                          away_team_win: 4.67,
                          draw: 3.01)
  end

  before do
    betting_odds_match_1
    betting_odds_match_2
  end

  context 'when the user always bet 100$ on Arsenal during the whole season' do
    let(:params) do
      {
        amount: 100,
        team: 'Arsenal',
        betting_strategy: Constants.betting.strategies.always_win
      }
    end

    it 'calculates potentil profit' do
      expect(subject).to eq((245 - 100) - 100)
    end
  end

  context 'when the user always bet 100$ on Arsenal loss during the whole season' do
    let(:params) do
      {
        amount: 100,
        team: 'Arsenal',
        betting_strategy: Constants.betting.strategies.always_lose
      }
    end

    it 'calculates potentil profit' do
      expect(subject).to eq((134 - 100) - 100)
    end
  end

  context 'when the user always bet 100$ on draw during the whole season' do
    let(:match_3) { create(:match, season:, home_team: 'Chelsea', away_team: 'Arsenal', score: '1:1') }
    let(:params) do
      {
        amount: 100,
        team: 'Arsenal',
        betting_strategy: Constants.betting.strategies.always_draw
      }
    end

    before do
      create(:betting_odds, match: match_3,
                            home_team_win: 1.64,
                            away_team_win: 3.67,
                            draw: 3.01)
    end

    it 'calculates potentil profit' do
      expect(subject).to eq(301 - 300)
    end
  end
end
