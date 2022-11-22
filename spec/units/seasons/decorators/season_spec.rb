# frozen_string_literal: true

require 'rails_helper'

describe Seasons::Decorators::Season do
  subject(:decorator) { described_class.new(season) }

  let(:season) { build_stubbed(:season, name: season_years) }

  describe '#active?' do
    subject { decorator.active? }

    before { travel_to '01.01.2022'.to_date }

    context 'when season is 2022/2023' do
      let(:season_years) { '2022/2023' }

      it { is_expected.to be true }
    end

    context 'when season is 2022' do
      let(:season_years) { '2022' }

      it { is_expected.to be true }
    end

    context 'when season is 2019/2020' do
      let(:season_years) { '2019/2020' }

      it { is_expected.to be false }
    end

    context 'when season is 2023/2024' do
      let(:season_years) { '2023/2024' }

      it { is_expected.to be false }
    end
  end
end
