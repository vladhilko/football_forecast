# frozen_string_literal: true

require 'rails_helper'

describe Countries::PopulateMatches::Action do
  subject { described_class.new(country:).call }

  let(:country) { build_stubbed(:country, name: 'England') }
  let(:premier_league) { build_stubbed(:league, name: 'Premier League') }
  let(:championship) { build_stubbed(:league, name: 'championship') }

  it 'calls Countries::PopulateMatchesJob with valid params' do
    expect(Queries::League).to receive(:by_country).with(country)
      .and_return([premier_league, championship])

    expect(Leagues::PopulateMatchesJob).to receive(:perform_async).with(premier_league.id)
    expect(Leagues::PopulateMatchesJob).to receive(:perform_async).with(championship.id)

    subject
  end
end
