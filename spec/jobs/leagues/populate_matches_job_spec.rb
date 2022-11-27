# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Leagues::PopulateMatchesJob, type: :job do
  subject { described_class.perform_async(league.id) }

  let(:league) { create(:league) }

  it 'call Leagues::PopulateMatches in async mode' do
    expect(Leagues::PopulateMatches::EntryPoint).to receive(:call).with(league:)

    subject
  end
end
