# frozen_string_literal: true

module Api
  module V1
    class TimeTravelSessionWagersController < Api::V1::ApplicationController

      def create
        wagers = ::Sportsbook::PlaceWagers.call(
          user: current_user,
          session: time_travel_session,
          selections: wager_selections,
          placement_key: request.headers['Idempotency-Key']
        )
        render json: {
          wagers: wagers.map { Serializer.wager(_1) },
          wallet: Serializer.wallet(current_user.wallet.reload)
        }, status: :created
      end

      private

      def time_travel_session
        @time_travel_session ||= current_user.time_travel_sessions.find_by!(uuid: params[:time_travel_session_id])
      end

      def wager_selections
        params.require(:selections).map do |selection|
          selection.permit(:fixture_id, :selection, :stake_minor).to_h
        end
      end

    end
  end
end
