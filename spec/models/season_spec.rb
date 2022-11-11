# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Season, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:league) }
    it { is_expected.to have_many(:matches) }
  end

  describe 'validations' do
    subject { described_class.new(name: '2020/2021', league:) }

    let(:league) { create(:league) }

    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:league_id) }
    it { is_expected.to validate_inclusion_of(:completeness_status).in_array(Season::COMPLETENESS_STATUSES) }
  end
end
