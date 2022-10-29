# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OddsportalScraper::Scrapers::Matches do
  describe '.by_sport_and_country_and_league_and_season' do
    subject { described_class.by_sport_and_country_and_league_and_season(sport_name, country, league, season) }

    context 'when choosen sport: `soccer`, country: `England`, league: `Premier League` and season: `2007-2008`' do
      let(:sport_name) { 'soccer' }
      let(:country) { 'England' }
      let(:league) { 'Premier League' }
      let(:season) { '2007-2008' }

      let(:expected_response) { parse_json_fixture('results/soccer/england/premier-league/2007-2008/matches.json') }

      it 'returns all mathes available for this sport, country, league and season' do
        expect(subject).to match_array(expected_response)
      end
    end
  end
end
