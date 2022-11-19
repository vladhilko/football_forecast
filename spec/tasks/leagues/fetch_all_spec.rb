# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rake leagues:fetch_all', type: :task do
  subject { Rake::Task['leagues:fetch_all'].execute }

  before do
    expect(OddsportalScraper).to receive(:leagues)
      .with(sport: 'soccer', country: england.name)
      .and_return(['Premier League', 'Championship', 'League One'])
    expect(OddsportalScraper).to receive(:leagues)
      .with(sport: 'soccer', country: spain.name)
      .and_return(%w[LaLiga LaLiga2])
  end

  let(:england) { create(:country, name: 'England') }
  let(:spain) { create(:country, name: 'Spain') }

  let(:expected_output) do
    <<~TEXT
      Adding England leagues
      Adding Spain leagues
      5 leagues have been added to the DB
    TEXT
  end

  it 'saves all fetched leagues to the db' do
    expect { subject }.to change(League, :count).by(5).and output(expected_output).to_stdout
  end

  context 'when league from the country has already been added to the database' do
    before { create(:league, country: england, name: 'Premier League') }

    let(:expected_output) do
      <<~TEXT
        Adding England leagues
        Adding Spain leagues
        4 leagues have been added to the DB
      TEXT
    end

    it 'saves only new fetched leagues' do
      expect { subject }.to change(League, :count).by(4).and output(expected_output).to_stdout
    end
  end
end
