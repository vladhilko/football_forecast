# frozen_string_literal: true

module Api
  module V1
    class TimeTravelSessionsController < Api::V1::ApplicationController

      def index
        sessions = current_user.time_travel_sessions.includes(:league, :session_matches,
                                                              :wagers).order(created_at: :desc)
        render json: { sessions: sessions.map { Serializer.session(_1) } }
      end

      def show
        render json: { session: Serializer.session(time_travel_session),
                       wallet: Serializer.wallet(current_user.wallet) }
      end

      def create
        session = ::Sportsbook::CreateTimeTravelSession.call(user: current_user, travel_on: params.require(:travel_on))
        render json: { session: Serializer.session(session.reload), wallet: Serializer.wallet(current_user.wallet) },
               status: :created
      end

      private

      def time_travel_session
        @time_travel_session ||= current_user.time_travel_sessions.find_by!(uuid: params[:id])
      end

    end
  end
end
