# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Countries::PopulateMatchesJob, type: :job do
  subject { described_class.perform_async(country.id) }

  let(:country) { create(:country) }

  it 'call Countries::PopulateMatches in async mode' do
    expect(Countries::PopulateMatches::EntryPoint).to receive(:call).with(country:)

    subject
  end
end
