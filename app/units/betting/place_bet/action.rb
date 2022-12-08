# frozen_string_literal: true

module Betting
  module PlaceBet
    class Action

      def initialize(match:, inputs:)
        @match = match
        @inputs = inputs
      end

      def call
        Command.save(bet)
      end

      private

      attr_reader :match, :inputs

      def bet
        Bet.new(
          match:,
          payout_amount:,
          odds:,
          status: 'pending',
          **inputs.attributes
        )
      end

      def payout_amount
        odds * bet_amount
      end

      def odds
        match.betting_odds.odds_for(team)
      end

      def bet_amount
        inputs.attributes.to_h.fetch(:bet_amount)
      end

      def team
        inputs.attributes.to_h.fetch(:team)
      end

    end
  end
end
