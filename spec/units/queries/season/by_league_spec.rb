# frozen_string_literal: true

require 'rails_helper'

describe Queries::Season do
  describe '.by_league' do
    subject { described_class.by_league(league_1) }

    let(:league_1) { create(:league, name: 'Liga 1') }
    let(:league_2) { create(:league, name: 'Liga 2') }

    let(:season_1) { create(:season, league: league_1, name: '2019/2020') }
    let(:season_2) { create(:season, league: league_1, name: '2020/2021') }
    let(:season_3) { create(:season, league: league_2, name: '2019/2020') }

    before do
      season_1
      season_2
      season_3
    end

    it { is_expected.to contain_exactly(season_1, season_2) }
  end
end
