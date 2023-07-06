# frozen_string_literal: true

RSpec.shared_examples 'with UUID' do
  subject { create(described_class.to_s.underscore, uuid:).uuid }

  context "when 'uuid' is nil" do
    let(:uuid) { nil }

    it { is_expected.not_to be_empty }
  end

  context "when 'uuid' is set" do
    let(:uuid) { 'abc' }

    it { is_expected.to eq uuid }
  end
end
