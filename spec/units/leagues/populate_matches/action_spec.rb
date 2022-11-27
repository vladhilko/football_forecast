# frozen_string_literal: true

require 'rails_helper'

describe Leagues::PopulateMatches::Action do
  subject { described_class.new(league: premier_league, season_status:).call }

  let(:premier_league) { build_stubbed(:league, name: 'Premier League') }
  let(:season_1) { build_stubbed(:season, name: '2020/2021') }
  let(:season_2) { build_stubbed(:season, name: '2021/2022') }
  let(:season_status) { Constants.season.completeness_statuses.initial }

  it 'calls Seasons::PopulateMatches unit with valid params' do
    expect(Queries::Season).to receive(:by_league_and_status).with(premier_league, season_status)
      .and_return([season_1, season_2])

    expect(Seasons::PopulateMatches::EntryPoint).to receive(:call).with(season: season_1)
    expect(Seasons::PopulateMatches::EntryPoint).to receive(:call).with(season: season_2)

    subject
  end
end
