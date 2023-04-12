# frozen_string_literal: true

module Betting
  module PlaceBet
    class Action

      def initialize(match:, form:)
        @match = match
        @form = form
      end

      def call
        Command.save(bet)
      end

      private

      attr_reader :match, :form

      def bet
        Bet.new(
          match:,
          payout_amount:,
          odds:,
          status: 'pending',
          **form.attributes
        )
      end

      def payout_amount
        odds * bet_amount
      end

      def odds
        case bet_type
        when 'win' then team_win_odds
        when 'lose' then team_lose_odds
        when 'draw' then draw_odds
        end
      end

      def team_win_odds
        match.betting_odds.odds_for(team)
      end

      def team_lose_odds
        match.betting_odds.odds_for(match.opponent_team(team))
      end

      def draw_odds
        match.betting_odds.draw
      end

      def bet_amount
        form.attributes.fetch(:bet_amount)
      end

      def team
        form.attributes.fetch(:team)
      end

      def bet_type
        form.attributes.fetch(:bet_type)
      end

    end
  end
end
