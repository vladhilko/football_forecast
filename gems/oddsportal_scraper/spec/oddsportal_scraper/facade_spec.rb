# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OddsportalScraper::Facade do
  describe '.sport_names' do
    subject { described_class.sport_names }

    before { allow(OddsportalScraper::Scrapers::SportNames).to receive(:call) }

    it 'calls correct scraper method' do
      subject

      expect(OddsportalScraper::Scrapers::SportNames).to have_received(:call)
    end
  end
end
