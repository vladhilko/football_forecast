# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Constants do
  describe 'Constants.season.completeness_statuses' do
    subject { described_class.season.completeness_statuses }

    %w[full initial partial ongoing empty].each do |status|
      it "returns correct value for #{status} status" do
        expect(subject.public_send(status.to_sym)).to eq(status)
      end
    end

    describe '.values' do
      subject { described_class.season.completeness_statuses.values }

      it { is_expected.to contain_exactly('full', 'initial', 'partial', 'ongoing', 'empty') }
    end
  end

  describe 'Constants.match.result_types' do
    subject { described_class.match.result_types }

    it 'returns correct value for `cancelled` status' do
      expect(subject.cancelled).to eq('canc.')
    end

    describe '.values' do
      subject { described_class.match.result_types.values }

      it { is_expected.to contain_exactly('canc.') }
    end
  end

  describe 'Constants.match.results' do
    subject { described_class.match.results }

    %w[home_team_win draw away_team_win].each do |result|
      it "returns correct value for #{result} result" do
        expect(subject.public_send(result.to_sym)).to eq(result)
      end
    end

    describe '.values' do
      subject { described_class.match.results.values }

      it { is_expected.to contain_exactly('home_team_win', 'draw', 'away_team_win') }
    end
  end

  describe 'Constants.active_admin.pages' do
    subject { described_class.active_admin.pages }

    it 'returns correct value for `calculate_season_profit` page' do
      expect(subject.calculate_season_profit).to eq('Calculate Season Profit')
    end

    describe '.values' do
      subject { described_class.active_admin.pages.values }

      it { is_expected.to contain_exactly('Calculate Season Profit') }
    end
  end

  describe 'Constants.betting.strategies' do
    subject { described_class.betting.strategies }

    %w[always_win always_lose always_draw].each do |result|
      it "returns correct value for #{result} result" do
        expect(subject.public_send(result.to_sym)).to eq(result)
      end
    end

    describe '.values' do
      subject { described_class.betting.strategies.values }

      it { is_expected.to contain_exactly('always_win', 'always_lose', 'always_draw') }
    end
  end

  describe 'implementation' do
    it 'raises FrozenError when trying to modify the constant' do
      expect { described_class.betting.strategies.always_win << 'update' }.to raise_error(FrozenError)
    end

    it 'raises FrozenError when trying to add something to the constant' do
      expect { described_class.betting.strategies['new_key'] = 'new_key' }.to raise_error(FrozenError)
    end

    it 'uses symbol keys instead of string for all nested levels' do
      expect(described_class.keys.all?(Symbol)).to be true
      expect(described_class.betting.keys.all?(Symbol)).to be true
      expect(described_class.betting.strategies.keys.all?(Symbol)).to be true
    end
  end
end
