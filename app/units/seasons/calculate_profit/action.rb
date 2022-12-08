# frozen_string_literal: true

module Seasons
  module CalculateProfit
    class Action

      def initialize(season:, params:)
        @season = season
        @params = params
        @team = params[:team]
        @amount = params[:amount]
      end

      def call
        initial_amount = bets.sum(&:bet_amount)
        final_amount = bets.select { _1.status == 'resolved' && _1.result == 'win' }.sum(&:payout_amount)

        final_amount - initial_amount
      end

      private

      attr_reader :season, :team, :amount

      def bets
        @bets ||= Queries::Match.by_season_and_team(season, team).map do |match|
          bet = Betting::PlaceBet::EntryPoint.call(match:, params: { bet_amount: amount, team:, bet_type: 'win' })
          Betting::ResolveBet::EntryPoint.call(bet)
        end
      end

    end
  end
end
