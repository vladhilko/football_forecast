# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Command do
  describe '.save!' do
    subject { described_class.save(entity) }

    let(:entity) { double }

    before { expect(entity).to receive(:save!) }

    it { is_expected.to eq entity }
  end
end
