# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rake seasons:fetch_all', type: :task do
  subject { Rake::Task['seasons:fetch_all'].execute }

  before do
    expect(OddsportalScraper).to receive(:seasons)
      .with(sport: 'soccer', country: england.name, league: premier_league.name)
      .and_return(['2007/2008', '2008/2009'])
    expect(OddsportalScraper).to receive(:seasons)
      .with(sport: 'soccer', country: england.name, league: championship.name)
      .and_return(['2010/2011'])
    expect(OddsportalScraper).to receive(:seasons)
      .with(sport: 'soccer', country: spain.name, league: laliga.name)
      .and_return(['2010/2011', '2011/2012'])
  end

  let(:england) { create(:country, name: 'England') }
  let(:spain) { create(:country, name: 'Spain') }

  let(:premier_league) { create(:league, country: england, name: 'Premier League') }
  let(:championship) { create(:league, country: england, name: 'Championship') }
  let(:laliga) { create(:league, country: spain, name: 'LaLiga') }

  let(:expected_output) do
    <<~TEXT
      Adding England Premier League seasons:
      2007/2008
      2008/2009
      Adding England Championship seasons:
      2010/2011
      Adding Spain LaLiga seasons:
      2010/2011
      2011/2012
      5 seasons have been added to the DB
    TEXT
  end

  it 'saves all fetched seasons to the db' do
    expect { subject }.to change(Season, :count).by(5).and output(expected_output).to_stdout
  end

  context 'when season from the league has already been added to the database' do
    before { create(:season, league: premier_league, name: '2008/2009') }

    let(:expected_output) do
      <<~TEXT
        Adding England Premier League seasons:
        2007/2008
        Adding England Championship seasons:
        2010/2011
        Adding Spain LaLiga seasons:
        2010/2011
        2011/2012
        4 seasons have been added to the DB
      TEXT
    end

    it 'saves only new fetched seasons' do
      expect { subject }.to change(Season, :count).by(4).and output(expected_output).to_stdout
    end
  end
end
