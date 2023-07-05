# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Settings::Platform::Repository do
  describe '#profit_calculation' do
    subject { described_class.profit_calculation }

    it 'returns correct platform specific values' do
      expect(subject).to include(
        'enabled' => true,
        'show_full_message' => false,
        'calculation_strategies' => %w[gross_profit net_profit other]
      )
    end

    it 'freezes all elements' do
      expect(subject).to be_frozen
      expect(subject['enabled']).to be_frozen
      expect(subject['show_full_message']).to be_frozen
    end
  end

  describe '#admin' do
    subject { described_class.admin }

    it 'returns correct platform specific values' do
      expect(subject).to include('show_profit_calculation_page' => true)
    end

    it 'freezes all elements' do
      expect(subject).to be_frozen
      expect(subject['show_profit_calculation_page']).to be_frozen
    end
  end
end
