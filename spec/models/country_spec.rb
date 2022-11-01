# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Country, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:leagues) }
  end

  describe 'validations' do
    subject { described_class.new(name: 'England') }

    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end
end
