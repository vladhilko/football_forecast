# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Match, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:season) }
    it { is_expected.to have_one(:betting_odds) }
  end

  describe 'validations' do
    subject do
      described_class.new(home_team: 'Arsenal', away_team: 'Chelsea', date: '01.12.2010', score: '2:1', season:)
    end

    let(:season) { create(:season) }

    it { is_expected.to validate_uniqueness_of(:home_team).case_insensitive.scoped_to(%i[season_id away_team date]) }
  end

  describe '#name' do
    subject { described_class.new(home_team: 'Arsenal', away_team: 'Chelsea').name }

    it { is_expected.to eq('Arsenal - Chelsea') }
  end

  describe '#result' do
    context 'when score is 3:1' do
      subject { described_class.new(score: '3:1').result }

      it { is_expected.to eq(Constants.match.results.home_team_win) }
    end

    context 'when score is 1:1' do
      subject { described_class.new(score: '1:1').result }

      it { is_expected.to eq(Constants.match.results.draw) }
    end

    context 'when score is 1:3' do
      subject { described_class.new(score: '1:3').result }

      it { is_expected.to eq(Constants.match.results.away_team_win) }
    end
  end

  describe '#home_team?' do
    context 'when Arsenal plays at home' do
      subject { described_class.new(home_team: 'Arsenal', away_team: 'Chelsea').home_team?('Arsenal') }

      it { is_expected.to be true }
    end

    context 'when Arsenal plays away' do
      subject { described_class.new(home_team: 'Chelsea', away_team: 'Arsenal').home_team?('Arsenal') }

      it { is_expected.to be false }
    end
  end
end
