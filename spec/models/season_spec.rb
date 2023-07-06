# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Season, type: :model do
  it_behaves_like 'with UUID'

  describe 'associations' do
    it { is_expected.to belong_to(:league) }
    it { is_expected.to have_many(:matches) }
  end

  describe 'validations' do
    subject { described_class.new(name: '2020/2021', league:) }

    let(:league) { create(:league) }

    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:league_id) }

    it do
      expect(subject).to validate_inclusion_of(:completeness_status)
        .in_array(Constants.season.completeness_statuses.values)
    end
  end

  describe '#completeness_statuses predicate methods' do
    subject { described_class.new(completeness_status:) }

    context 'when completeness_status is initial' do
      let(:completeness_status) { Constants.season.completeness_statuses.initial }

      it 'returns correct value for the predicate methods' do
        expect(subject.completeness_status_initial?).to be true
        expect(subject.completeness_status_full?).to be false
        expect(subject.completeness_status_partial?).to be false
        expect(subject.completeness_status_ongoing?).to be false
        expect(subject.completeness_status_empty?).to be false
      end
    end

    context 'when completeness_status is full' do
      let(:completeness_status) { Constants.season.completeness_statuses.full }

      it 'returns correct value for the predicate methods' do
        expect(subject.completeness_status_initial?).to be false
        expect(subject.completeness_status_full?).to be true
        expect(subject.completeness_status_partial?).to be false
        expect(subject.completeness_status_ongoing?).to be false
        expect(subject.completeness_status_empty?).to be false
      end
    end

    context 'when completeness_status is partial' do
      let(:completeness_status) { Constants.season.completeness_statuses.partial }

      it 'returns correct value for the predicate methods' do
        expect(subject.completeness_status_initial?).to be false
        expect(subject.completeness_status_full?).to be false
        expect(subject.completeness_status_partial?).to be true
        expect(subject.completeness_status_ongoing?).to be false
        expect(subject.completeness_status_empty?).to be false
      end
    end

    context 'when completeness_status is ongoing' do
      let(:completeness_status) { Constants.season.completeness_statuses.ongoing }

      it 'returns correct value for the predicate methods' do
        expect(subject.completeness_status_initial?).to be false
        expect(subject.completeness_status_full?).to be false
        expect(subject.completeness_status_partial?).to be false
        expect(subject.completeness_status_ongoing?).to be true
        expect(subject.completeness_status_empty?).to be false
      end
    end

    context 'when completeness_status is empty' do
      let(:completeness_status) { Constants.season.completeness_statuses.empty }

      it 'returns correct value for the predicate methods' do
        expect(subject.completeness_status_initial?).to be false
        expect(subject.completeness_status_full?).to be false
        expect(subject.completeness_status_partial?).to be false
        expect(subject.completeness_status_ongoing?).to be false
        expect(subject.completeness_status_empty?).to be true
      end
    end
  end
end
