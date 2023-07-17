# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TemporaryDataStoreAdapter::Memory do
  let(:memory_adapter) { described_class.new }

  after { memory_adapter.clear }

  describe '#set' do
    subject { memory_adapter.set('key', { 'example' => 'example' }) }

    it 'saved the value by the key and returns status OK' do
      subject

      expect(subject).to eq('OK')
      expect(memory_adapter.get('key')).to eq({ 'example' => 'example' })
    end
  end

  describe '#get' do
    subject { memory_adapter.get('key') }

    context 'when the given key is present' do
      before { memory_adapter.set('key', { 'example' => 'example' }) }

      it { is_expected.to eq({ 'example' => 'example' }) }
    end

    context 'when the given key does not exist' do
      it { is_expected.to be_nil }
    end
  end

  describe '#delete' do
    subject { memory_adapter.delete('key') }

    context 'when the given key is present' do
      before { memory_adapter.set('key', { 'example' => 'example' }) }

      it 'removes the entry and return value' do
        subject

        expect(subject).to eq({ 'example' => 'example' })
        expect(memory_adapter.get('key')).to be_nil
      end
    end

    context 'when the given key does not exist' do
      it { is_expected.to be_nil }
    end
  end
end
