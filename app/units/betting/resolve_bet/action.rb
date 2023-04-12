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
        bet.result = bet_result

        bet
      end

      def bet_result
        bet.bet_type == match_result ? 'win' : 'lose'
      end

      def match_result
        bet.match.result_for(bet.team)
      end

    end
  end
end
