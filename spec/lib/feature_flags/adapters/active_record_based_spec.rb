# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeatureFlags::Adapters::ActiveRecordBased do
  let(:supported_flag) { 'supported' }
  let(:not_supported_flag) { 'not_supported' }
  let(:ar_adapter) { Flipper::Adapters::ActiveRecord.new }

  before do
    allow(FeatureFlag).to receive(:supported?).with(not_supported_flag).and_return(false)
    allow(FeatureFlag).to receive(:supported?).with(supported_flag).and_return(true)
  end

  describe '#add' do
    subject { described_class.new.add(flag) }

    context 'when flag is supported' do
      let(:flag) { Flipper::Feature.new(supported_flag, ar_adapter) }

      it 'calls active_record client' do
        expect(Flipper::Adapters::ActiveRecord::Feature).to receive(:create!)

        subject
      end
    end

    context 'when flag is not supported' do
      let(:flag) { Flipper::Feature.new(not_supported_flag, ar_adapter) }

      it { is_expected.to be false }

      it 'does not call active_record client' do
        expect(Flipper::Adapters::ActiveRecord::Feature).not_to receive(:create!)

        subject
      end
    end
  end

  describe '#enable' do
    subject do
      described_class.new.enable(
        flag,
        Flipper::Gates::Boolean.new,
        Flipper::Types::Boolean.new
      )
    end

    context 'when flag is supported' do
      let(:flag) { Flipper::Feature.new(supported_flag, ar_adapter) }

      it 'calls active_record client' do
        expect(Flipper::Adapters::ActiveRecord::Gate).to receive(:create!)

        subject
      end
    end

    context 'when flag is not supported' do
      let(:flag) { Flipper::Feature.new(not_supported_flag, ar_adapter) }

      it { is_expected.to be false }

      it 'does not call active_record client' do
        expect(Flipper::Adapters::ActiveRecord::Gate).not_to receive(:create!)

        subject
      end
    end
  end

  describe '#remove' do
    subject { described_class.new.remove(flag) }

    context 'when flag is supported' do
      let(:flag) { Flipper::Feature.new(supported_flag, ar_adapter) }

      it { is_expected.to be false }
    end

    context 'when flag is not supported' do
      let(:flag) { Flipper::Feature.new(not_supported_flag, ar_adapter) }

      it { is_expected.to be true }
    end
  end
end
