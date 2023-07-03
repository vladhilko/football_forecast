# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Settings::Platform::Mixin do
  describe '#platform_profit_calculation' do
    subject(:platform_profit_calculation) { klass.new.platform_profit_calculation }

    let(:klass) do
      Class.new do
        include Settings::Platform::Mixin[:profit_calculation]
      end
    end

    it 'returns correct platform specific values' do
      expect(platform_profit_calculation.enabled).to be true
      expect(platform_profit_calculation.enabled?).to be true

      expect(platform_profit_calculation.show_full_message).to be true
      expect(platform_profit_calculation.show_full_message?).to be true

      expect(platform_profit_calculation.calculation_strategies).to eq(%w[gross_profit net_profit other])
    end

    context 'when platform settings were changed in the spec' do
      include_context 'when platform settings are', profit_calculation: {
        'enabled' => false,
        'show_full_message' => false,
        'calculation_strategies' => []
      }

      it 'returns correct platform specific values' do
        expect(platform_profit_calculation.enabled).to be false
        expect(platform_profit_calculation.enabled?).to be false

        expect(platform_profit_calculation.show_full_message).to be false
        expect(platform_profit_calculation.show_full_message?).to be false

        expect(platform_profit_calculation.calculation_strategies).to eq([])
      end
    end
  end

  describe '#admin' do
    subject(:platform_admin) { klass.new.platform_admin }

    let(:klass) do
      Class.new do
        include Settings::Platform::Mixin[:admin]
      end
    end

    it 'returns correct platform specific values' do
      expect(platform_admin.show_profit_calculation_page).to be true
      expect(platform_admin.show_profit_calculation_page?).to be true
    end
  end
end
