# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'rake countries:fetch', type: :task do
  subject { Rake::Task['countries:fetch'].execute }

  before do
    expect(OddsportalScraper).to receive(:countries).with(sport: 'soccer').and_return(%w[England Spain Russia])
  end

  it 'saves all fetched countries to the db' do
    expect { subject }.to change(Country, :count).by(3)
      .and output("3 countries have been added to the DB\n").to_stdout
  end

  context 'when country has already been added to the database' do
    before { create(:country, name: 'England') }

    it 'saves only new fetched countries' do
      expect { subject }.to change(Country, :count).by(2)
        .and output("2 countries have been added to the DB\n").to_stdout
    end
  end
end
