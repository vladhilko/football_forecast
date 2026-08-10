# frozen_string_literal: true

module Sportsbook
  class RoundSelector

    ROUND_SIZE = 10
    MAX_ROUND_SPAN = 21.days
    SEARCH_LIMIT = 180

    def self.call(league:, travel_on:)
      new(league:, travel_on:).call
    end

    def initialize(league:, travel_on:)
      @league = league
      @travel_on = travel_on
    end

    def call
      eligible_matches.each_index do |anchor_index|
        round = build_round_from(anchor_index)
        return round if round.size == ROUND_SIZE
      end

      raise Error.new('round_unavailable', 'No complete historical Premier League round is available after that date')
    end

    private

    attr_reader :league, :travel_on

    def eligible_matches
      @eligible_matches ||= Match
                            .joins(:betting_odds, :season)
                            .includes(:betting_odds, :season)
                            .where(seasons: { league_id: league.id })
                            .where(date: travel_on...Date.current)
                            .order(:date, :time, :id)
                            .limit(SEARCH_LIMIT)
                            .select { eligible?(_1) }
    end

    def build_round_from(anchor_index)
      anchor = eligible_matches.fetch(anchor_index)
      teams = Set.new

      eligible_matches.drop(anchor_index).each_with_object([]) do |match, round|
        break round if outside_round?(match, anchor)
        next if team_already_used?(teams, match)

        round << match
        teams.merge([match.home_team, match.away_team])
        break round if round.size == ROUND_SIZE
      end
    end

    def outside_round?(match, anchor)
      match.season_id != anchor.season_id || match.date > anchor.date + MAX_ROUND_SPAN
    end

    def team_already_used?(teams, match)
      teams.include?(match.home_team) || teams.include?(match.away_team)
    end

    def eligible?(match)
      match.score.match?(/\A\d+:\d+\z/) &&
        [match.betting_odds.home_team_win, match.betting_odds.draw, match.betting_odds.away_team_win].all?(&:positive?)
    end

  end
end
