# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Seasons::PopulateMatchesJob, type: :job do
  subject { described_class.perform_async(season.id) }

  let(:season) { create(:season) }

  it 'call Seasons::PopulateMatches in async mode' do
    expect(Seasons::PopulateMatches::EntryPoint).to receive(:call).with(season:)

    subject
  end
end
