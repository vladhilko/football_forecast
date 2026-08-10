# frozen_string_literal: true

module Api
  module V1
    class SportsbookController < Api::V1::ApplicationController

      def bootstrap
        render json: {
          user: Serializer.user(current_user),
          wallet: Serializer.wallet(current_user.wallet),
          default_league: league_payload,
          available_dates: available_dates
        }
      end

      private

      def league
        @league ||= League.joins(:country).find_by!(name: 'Premier League', countries: { name: 'England' })
      end

      def league_payload
        { id: league.id, name: league.name, country: league.country.name }
      end

      def available_dates
        dates = Match.joins(:season).where(seasons: { league_id: league.id })
        { from: dates.minimum(:date)&.iso8601, to: dates.maximum(:date)&.iso8601 }
      end

    end
  end
end
