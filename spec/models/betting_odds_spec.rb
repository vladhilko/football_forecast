# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BettingOdds, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:match) }
  end

  describe '#odds_for(team)' do
    subject { described_class.new(home_team_win: 2.45, away_team_win: 2.67, match:).odds_for('Arsenal') }

    context 'when the team plays at home' do
      let(:match) { create(:match, home_team: 'Arsenal') }

      it { is_expected.to eq 2.45 }
    end

    context 'when the team plays away' do
      let(:match) { create(:match, away_team: 'Arsenal') }

      it { is_expected.to eq 2.67 }
    end
  end
end
