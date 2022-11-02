# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Season, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:league) }
  end

  describe 'validations' do
    subject { described_class.new(name: '2020/2021', league:) }

    let(:league) { create(:league) }

    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:league_id) }
  end
end
