# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Constants do
  describe 'Constants.season.completeness_statuses' do
    subject { described_class.season.completeness_statuses }

    %w[full initial partial ongoing empty].each do |status|
      it "returns correct value for #{status} status" do
        expect(subject.public_send(status.to_sym)).to eq(status)
      end
    end

    describe '.values' do
      subject { described_class.season.completeness_statuses.values }

      it { is_expected.to contain_exactly('full', 'initial', 'partial', 'ongoing', 'empty') }
    end
  end
end
