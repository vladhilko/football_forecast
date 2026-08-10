# frozen_string_literal: true

require 'digest'

module Sportsbook
  class CreateTimeTravelSession

    DEFAULT_COUNTRY = 'England'
    DEFAULT_LEAGUE = 'Premier League'
    KICKOFF_TIMEZONE = 'Europe/London'

    def self.call(user:, travel_on:)
      new(user:, travel_on:).call
    end

    def initialize(user:, travel_on:)
      @user = user
      @travel_on = Date.iso8601(travel_on.to_s)
    rescue Date::Error
      raise Error.new('invalid_travel_date', 'Travel date must be a valid ISO date')
    end

    def call
      prepare_round!
      existing = user.time_travel_sessions.find_by(round_fingerprint: fingerprint)
      return existing if existing

      TimeTravelSession.transaction { create_session }
    rescue ActiveRecord::RecordNotUnique
      user.time_travel_sessions.find_by!(round_fingerprint: fingerprint)
    end

    private

    attr_reader :user, :travel_on, :matches, :fingerprint

    def prepare_round!
      @matches = RoundSelector.call(league:, travel_on:)
      @fingerprint = Digest::SHA256.hexdigest(matches.map(&:id).join(':'))
    end

    def create_session
      session = user.time_travel_sessions.create!(session_attributes)
      matches.each_with_index { |match, position| snapshot_match(session, match, position) }
      session
    end

    def session_attributes
      { league:, travel_on:, round_fingerprint: fingerprint, reveal_mode: user.preferred_reveal_mode }
    end

    def league
      @league ||= League.joins(:country).find_by!(name: DEFAULT_LEAGUE, countries: { name: DEFAULT_COUNTRY })
    rescue ActiveRecord::RecordNotFound
      raise Error.new('league_unavailable', 'England Premier League data has not been imported')
    end

    def snapshot_match(session, match, position)
      home_score, away_score = match.score.split(':').map(&:to_i)
      session.session_matches.create!(snapshot_attributes(match, position, home_score, away_score))
    end

    def snapshot_attributes(match, position, home_score, away_score) # rubocop:disable Metrics/MethodLength
      {
        source_match: match,
        position:,
        home_team: match.home_team,
        away_team: match.away_team,
        kickoff_at: kickoff_at(match),
        kickoff_timezone: KICKOFF_TIMEZONE,
        home_odds: match.betting_odds.home_team_win,
        draw_odds: match.betting_odds.draw,
        away_odds: match.betting_odds.away_team_win,
        final_home_score: home_score,
        final_away_score: away_score,
        synthetic_events: synthetic_events(match, home_score, away_score)
      }
    end

    def kickoff_at(match)
      zone = ActiveSupport::TimeZone[KICKOFF_TIMEZONE]
      zone.local(match.date.year, match.date.month, match.date.day, match.time.hour, match.time.min).utc
    end

    def synthetic_events(match, home_score, away_score) # rubocop:disable Metrics/AbcSize
      sides = (['home'] * home_score) + (['away'] * away_score)
      return [] if sides.empty?

      random = Random.new(Digest::SHA256.hexdigest(match.id.to_s).first(8).to_i(16))
      minutes = (5..88).to_a.sample(sides.size, random:).sort
      events = sides.shuffle(random:).zip(minutes).map { |side, minute| { side:, minute: } }
      events.sort_by { _1.fetch(:minute) }
    end

  end
end
