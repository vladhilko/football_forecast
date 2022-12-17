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
        match.betting_odds.odds_for(team)
      end

      def bet_amount
        form.attributes.fetch(:bet_amount)
      end

      def team
        form.attributes.fetch(:team)
      end

    end
  end
end
