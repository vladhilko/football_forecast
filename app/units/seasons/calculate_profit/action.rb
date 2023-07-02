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

        if Settings::Platform::Repository.profit_calculation.fetch('show_full_message', false)
          final_amount - initial_amount
        else
          "The seasonal profit has been calculated and is equal to #{final_amount - initial_amount}"
        end
      end

      private

      attr_reader :season, :form

      def bets
        @bets ||= Queries::Match.by_season_and_team(season, team).map do |match|
          bet = place_bet.call(match:, params: { bet_amount: amount, team:, bet_type: })
          resolve_bet.call(bet)
        end
      end

      def team
        @team ||= form.attributes.fetch(:team)
      end

      def amount
        @amount ||= form.attributes.fetch(:amount)
      end

      def betting_strategy
        @betting_strategy ||= form.attributes.fetch(:betting_strategy)
      end

      def bet_type
        case betting_strategy
        when Constants.betting.strategies.always_win
          'win'
        when Constants.betting.strategies.always_draw
          'draw'
        when Constants.betting.strategies.always_lose
          'lose'
        end
      end

    end
  end
end
