# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeatureFlag do
  describe '.supported_names' do
    subject { described_class.supported_names }

    it { is_expected.to eq(Constants.feature_flags.pluck(:name)) }
  end

  describe '.supported?' do
    subject { described_class.supported?(flag) }

    context 'when flag is supported' do
      let(:flag) { Constants.feature_flags.first[:name] }

      it { is_expected.to be(true) }
    end

    context 'when flag is not supported' do
      let(:flag) { 'not_supported' }

      it { is_expected.to be(false) }
    end
  end
end
