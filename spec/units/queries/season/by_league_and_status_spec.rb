# frozen_string_literal: true

require 'rails_helper'

describe Queries::Season do
  describe '.by_league_and_status' do
    subject { described_class.by_league_and_status(league_1, initial_status) }

    let(:league_1) { create(:league, name: 'Liga 1') }
    let(:league_2) { create(:league, name: 'Liga 2') }

    let(:initial_status) { Constants.season.completeness_statuses.initial }
    let(:ongoing_status) { Constants.season.completeness_statuses.ongoing }

    let(:season_1) { create(:season, league: league_1, name: '2019/2020', completeness_status: initial_status) }
    let(:season_2) { create(:season, league: league_1, name: '2020/2021', completeness_status: ongoing_status) }
    let(:season_3) { create(:season, league: league_2, name: '2019/2020', completeness_status: initial_status) }

    before do
      season_1
      season_2
      season_3
    end

    it { is_expected.to contain_exactly(season_1) }
  end
end
