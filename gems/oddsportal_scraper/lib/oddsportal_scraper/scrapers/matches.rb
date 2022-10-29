# frozen_string_literal: true

require 'kimurai'
require 'pry'

module OddsportalScraper
  module Scrapers
    class Matches < Kimurai::Base

      @name = 'match_scraper'
      @engine = :selenium_chrome

      def self.by_sport_and_country_and_league_and_season(sport, country, league, season)
        @sport = sport
        @country = country.downcase
        @league = league.downcase.split(' ').join('-')
        @season = season

        @path = "#{@sport}/#{@country}/#{@league}-#{@season}/results/"
        url = "https://www.oddsportal.com/#{@path}"

        parse!(:parse, url:)
      end

      def parse(response, url:, **)
        last_page_num = response.css('div#pagination a').last.attributes.fetch('href').value.split('/').last.to_i
        all_season_matches = []

        (1..last_page_num).each do |page_number|
          browser.visit("#{url}#/page/#{page_number}/")
          all_season_matches.concat(parse_page_with_matches)
        end
        all_season_matches
      end

      private

      def parse_page_with_matches # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        tournament_table = browser.current_response.css('div#tournamentTable')

        matches = []
        match_date = nil
        tournament_table.css('tr').each do |match_day|
          if match_day.css('span.datet').text.present?
            match_date = match_day.css('span.datet').text
          elsif match_day.css('td.table-time').text.present?
            match_time = match_day.css('td.table-time').text
            participants = match_day.css('td.table-participant a').text
            score = match_day.css('td.table-score').text
            home_win, draw, away_win = match_day.css('td.odds-nowrp a').children.map(&:to_s)

            matches << {
              match_date:,
              match_time:,
              participants:,
              score:,
              odds: { home_win:, draw:, away_win: }
            }
          end
        end
        matches
      end

    end
  end
end
