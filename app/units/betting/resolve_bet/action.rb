# frozen_string_literal: true

module Betting
  module ResolveBet
    class Action

      def initialize(bet)
        @bet = bet
      end

      def call
        Command.save(updated_bet)
      end

      private

      attr_reader :bet

      def updated_bet
        bet.status = 'resolved'
        bet.result = result

        bet
      end

      def result
        bet.match.result_for(bet.team)
      end

    end
  end
end
