# frozen_string_literal: true

module Seasons
  module CalculateProfit
    class Action

      include BettingDependencies['place_bet', 'resolve_bet']

      def initialize(season:, form:, **deps)
        super(**deps)

        @season = season
        @form = form
      end

      def call
        initial_amount = bets.sum(&:bet_amount)
        final_amount = bets.select { _1.status == 'resolved' && _1.result == 'win' }.sum(&:payout_amount)

        final_amount - initial_amount
      end

      private

      attr_reader :season, :form

      def bets
        @bets ||= Queries::Match.by_season_and_team(season, team).map do |match|
          bet = place_bet.call(match:, params: { bet_amount: amount, team:, bet_type: 'win' })
          resolve_bet.call(bet)
        end
      end

      def team
        @team ||= form.attributes.to_h.fetch(:team)
      end

      def amount
        @amount ||= form.attributes.to_h.fetch(:amount)
      end

    end
  end
end
