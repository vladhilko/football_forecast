# frozen_string_literal: true

require_relative 'oddsportal_scraper/version'
require_relative 'oddsportal_scraper/facade'
require_relative 'oddsportal_scraper/scrapers/base'
require_relative 'oddsportal_scraper/scrapers/sport_names'
require_relative 'oddsportal_scraper/scrapers/countries'
require_relative 'oddsportal_scraper/scrapers/leagues'

module OddsportalScraper
  class Error < StandardError; end
  # Your code goes here...
end
