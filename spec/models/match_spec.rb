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
end
