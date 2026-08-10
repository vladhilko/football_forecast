# frozen_string_literal: true

module Sportsbook
  class RevealSnapshot

    HONEST_RESULTS_START = 33.0

    def self.call(session:, now: Time.current)
      new(session:, now:).call
    end

    def initialize(session:, now:)
      @session = session
      @now = now
    end

    def call
      settle_if_ready
      session.reload
      elapsed = session.reveal_elapsed(now)
      snapshot(elapsed)
    end

    def snapshot(elapsed) # rubocop:disable Metrics/MethodLength
      {
        status: session.status,
        phase: phase(elapsed),
        elapsed_seconds: elapsed.round(1),
        duration_seconds: TimeTravelSession::REVEAL_DURATION.to_i,
        match_minute: match_minute(elapsed),
        reveal_mode: session.reveal_mode,
        fixtures: session.session_matches.map { fixture_snapshot(_1, elapsed) },
        wagers: serialized_wagers,
        wallet: Api::V1::Serializer.wallet(session.user.wallet)
      }
    end

    private

    attr_reader :session, :now

    def settle_if_ready
      SettleSession.call(session:, now:) if session.reveal_deadline && now >= session.reveal_deadline
    end

    def serialized_wagers
      session.wagers.order(:id).map do |wager|
        Api::V1::Serializer.wager(wager, reveal_result: session.status == 'settled')
      end
    end

    def phase(elapsed)
      return 'betting' if session.status == 'betting'
      return 'settled' if session.status == 'settled'
      return 'portal' if elapsed < 8
      return 'accelerating' if elapsed < HONEST_RESULTS_START

      'final_whistle'
    end

    def match_minute(elapsed)
      [(elapsed / TimeTravelSession::REVEAL_DURATION.to_f * 90).floor, 90].min
    end

    def fixture_snapshot(fixture, elapsed)
      base = { id: fixture.uuid, position: fixture.position }
      if session.reveal_mode == 'synthetic'
        base.merge(synthetic_score(fixture, elapsed))
      else
        base.merge(honest_score(fixture, elapsed))
      end
    end

    def honest_score(fixture, elapsed)
      reveal_at = HONEST_RESULTS_START + (fixture.position * 1.1)
      return { revealed: false } if elapsed < reveal_at && session.status != 'settled'

      final_score(fixture)
    end

    def synthetic_score(fixture, elapsed)
      minute = match_minute(elapsed)
      events = Array(fixture.synthetic_events).select { event_minute(_1) <= minute }
      return final_score(fixture).merge(events:) if session.status == 'settled'

      {
        revealed: events.any?,
        home_score: events.count { event_side(_1) == 'home' },
        away_score: events.count { event_side(_1) == 'away' },
        events:
      }
    end

    def event_minute(event)
      event['minute'] || event[:minute]
    end

    def event_side(event)
      event['side'] || event[:side]
    end

    def final_score(fixture)
      {
        revealed: true,
        home_score: fixture.final_home_score,
        away_score: fixture.final_away_score,
        result: fixture.final_selection
      }
    end

  end
end
