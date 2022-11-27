# frozen_string_literal: true

require 'rails_helper'

describe Queries::Season do
  describe '.by_completeness_status' do
    subject { described_class.by_completeness_status(initial_status) }

    let(:initial_status) { Constants.season.completeness_statuses.initial }
    let(:ongoing_status) { Constants.season.completeness_statuses.ongoing }

    let(:season_1) { create(:season, name: '2019/2020', completeness_status: initial_status) }
    let(:season_2) { create(:season, name: '2020/2021', completeness_status: ongoing_status) }

    before do
      season_1
      season_2
    end

    it { is_expected.to contain_exactly(season_1) }
  end
end
