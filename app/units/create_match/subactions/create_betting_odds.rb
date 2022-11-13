# frozen_string_literal: true

module CreateMatch
  module Subactions
    class CreateBettingOdds

      def initialize(match:, params:)
        @match = match
        @params = params
      end

      def call
        Command.save betting_odds
      end

      private

      attr_reader :params, :match

      def betting_odds
        BettingOdds.new(params.merge(match_id: match.id))
      end

    end
  end
end
