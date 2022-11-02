# frozen_string_literal: true

require 'rails_helper'

RSpec.describe League, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:country) }
    it { is_expected.to have_many(:seasons) }
  end

  describe 'validations' do
    subject { described_class.new(name: 'Premier League', country:) }

    let(:country) { create(:country) }

    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:country_id) }
  end
end
