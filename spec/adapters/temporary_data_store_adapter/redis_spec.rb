# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TemporaryDataStoreAdapter::Redis do
  let(:redis_adapter) { described_class.new }

  describe '#set' do
    subject { redis_adapter.set('key', { 'example' => 'example' }) }

    it 'saved the value by the key and returns status OK' do
      subject

      expect(subject).to eq('OK')
      expect(redis_adapter.get('key')).to eq({ 'example' => 'example' })
    end
  end

  describe '#get' do
    subject { redis_adapter.get('key') }

    context 'when the given key is present' do
      before { redis_adapter.set('key', { 'example' => 'example' }) }

      it { is_expected.to eq({ 'example' => 'example' }) }
    end

    context 'when the given key does not exist' do
      it { is_expected.to be_nil }
    end
  end

  describe '#delete' do
    subject { redis_adapter.delete('key') }

    context 'when the given key is present' do
      before { redis_adapter.set('key', { 'example' => 'example' }) }

      it 'removes the entry and return value' do
        subject

        expect(subject).to eq({ 'example' => 'example' })
        expect(redis_adapter.get('key')).to be_nil
      end
    end

    context 'when the given key does not exist' do
      it { is_expected.to be_nil }
    end
  end
end
