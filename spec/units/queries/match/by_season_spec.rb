# frozen_string_literal: true

require 'rails_helper'

describe Queries::Match do
  describe '.by_season' do
    subject { described_class.by_season(season_1) }

    let(:season_1) { create(:season, name: '2021/2022') }
    let(:season_2) { create(:season, name: '2019/2020') }

    let(:match_1) { create(:match, season: season_1, home_team: 'Arsenal', away_team: 'Liverpool') }
    let(:match_2) { create(:match, season: season_1, home_team: 'Liverpool', away_team: 'Arsenal') }
    let(:match_3) { create(:match, season: season_2, home_team: 'Arsenal', away_team: 'Liverpool') }

    before do
      season_1
      season_2

      match_1
      match_2
      match_3
    end

    it { is_expected.to contain_exactly(match_1, match_2) }
  end
end
