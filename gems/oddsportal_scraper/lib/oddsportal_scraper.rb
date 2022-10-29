# frozen_string_literal: true

require_relative 'oddsportal_scraper/version'
require_relative 'oddsportal_scraper/facade'
require_relative 'oddsportal_scraper/scrapers/base'
require_relative 'oddsportal_scraper/scrapers/sport_names'
require_relative 'oddsportal_scraper/scrapers/countries'
require_relative 'oddsportal_scraper/scrapers/leagues'
require_relative 'oddsportal_scraper/scrapers/seasons'
require_relative 'oddsportal_scraper/scrapers/matches'

module OddsportalScraper
  ROOT_DIR = File.expand_path('..', __dir__)

  class Error < StandardError; end
end
