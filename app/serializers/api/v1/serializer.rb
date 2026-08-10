# frozen_string_literal: true

module Api
  module V1
    module Serializer # rubocop:disable Metrics/ModuleLength
      module_function

      def user(user)
        {
          id: user.uuid,
          display_name: user.display_name,
          email: user.email,
          status: user.status,
          preferred_reveal_mode: user.preferred_reveal_mode
        }
      end

      def wallet(wallet)
        {
          currency: wallet.currency,
          balance_minor: wallet.balance_minor,
          balance: format_money(wallet.balance_minor)
        }
      end

      def session(session, include_wagers: true)
        payload = session_attributes(session)
        payload[:wagers] = serialized_wagers(session) if include_wagers
        payload
      end

      def session_attributes(session)
        {
          id: session.uuid,
          status: session.status,
          travel_on: session.travel_on.iso8601,
          reveal_mode: session.reveal_mode,
          reveal_started_at: session.reveal_started_at&.iso8601,
          league: league(session.league),
          fixtures: serialized_fixtures(session)
        }
      end

      def league(league)
        { id: league.id, name: league.name, country: league.country.name }
      end

      def serialized_fixtures(session)
        session.session_matches.map { fixture(_1, reveal_result: session.status == 'settled') }
      end

      def serialized_wagers(session)
        session.wagers.order(:id).map { wager(_1, reveal_result: session.status == 'settled') }
      end

      def fixture(fixture, reveal_result: false)
        fixture_attributes(fixture).tap do |payload|
          payload[:final_score] = final_score(fixture) if reveal_result
        end
      end

      def fixture_attributes(fixture)
        {
          id: fixture.uuid,
          position: fixture.position,
          home_team: fixture.home_team,
          away_team: fixture.away_team,
          kickoff_at: fixture.kickoff_at.iso8601,
          kickoff_timezone: fixture.kickoff_timezone,
          odds: odds(fixture)
        }
      end

      def odds(fixture)
        {
          home: fixture.home_odds.to_s('F'),
          draw: fixture.draw_odds.to_s('F'),
          away: fixture.away_odds.to_s('F')
        }
      end

      def final_score(fixture)
        { home: fixture.final_home_score, away: fixture.final_away_score, result: fixture.final_selection }
      end

      def wager(wager, reveal_result: false)
        wager_attributes(wager).tap do |payload|
          payload.merge!(reveal_result ? wager_result(wager) : { status: 'pending' })
        end
      end

      def wager_attributes(wager)
        {
          id: wager.uuid,
          fixture_id: wager.time_travel_session_match.uuid,
          selection: wager.selection,
          decimal_odds: wager.decimal_odds.to_s('F'),
          placed_at: wager.placed_at.iso8601,
          **wager_money(wager)
        }
      end

      def wager_money(wager)
        { stake_minor: wager.stake_minor, stake: format_money(wager.stake_minor),
          potential_payout_minor: wager.potential_payout_minor,
          potential_payout: format_money(wager.potential_payout_minor) }
      end

      def wager_result(wager)
        profit_minor = wager.payout_minor - wager.stake_minor
        {
          status: wager.status,
          payout_minor: wager.payout_minor,
          payout: format_money(wager.payout_minor),
          profit_minor:,
          profit: format_money(profit_minor),
          settled_at: wager.settled_at&.iso8601
        }
      end

      def format_money(minor)
        format('%.2f', minor.to_i / 100.0)
      end
    end
  end
end
