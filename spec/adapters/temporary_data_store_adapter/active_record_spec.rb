# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TemporaryDataStoreAdapter::ActiveRecord do
  let(:active_record_adapter) { described_class.new }

  describe '#set' do
    subject { active_record_adapter.set('key', { 'example' => 'example' }) }

    context 'when data entry with the given key does not exist' do
      it 'creates a new entry with given values and returns ok status' do
        subject

        expect(active_record_adapter.get('key')).to eq({ 'example' => 'example' })
        expect(subject).to eq('OK')
      end
    end

    context 'when data entry with the given key is already present' do
      before { create(:temporary_data_entry, key: 'key', data: 'old_value') }

      it 'updates the data and returns ok status' do
        subject

        expect(active_record_adapter.get('key')).to eq({ 'example' => 'example' })
        expect(subject).to eq('OK')
      end
    end
  end

  describe '#get' do
    subject { active_record_adapter.get('key') }

    context 'when data entry is present' do
      before { active_record_adapter.set('key', { 'example' => 'example' }) }

      it { is_expected.to eq({ 'example' => 'example' }) }
    end

    context 'when data entry does not exist' do
      it { is_expected.to be_nil }
    end
  end

  describe '#delete' do
    subject { active_record_adapter.delete('key') }

    context 'when data entry is present' do
      before { active_record_adapter.set('key', { 'example' => 'example' }) }

      it 'removes the entry and return value' do
        subject

        expect(active_record_adapter.get('key')).to be_nil
        expect(subject).to eq({ 'example' => 'example' })
      end
    end

    context 'when data entry does not exist' do
      it { is_expected.to be_nil }
    end
  end
end
