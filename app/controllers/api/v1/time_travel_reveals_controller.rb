# frozen_string_literal: true

module Api
  module V1
    class TimeTravelRevealsController < Api::V1::ApplicationController

      def create
        ::Sportsbook::StartReveal.call(session: time_travel_session)
        render json: { reveal: ::Sportsbook::RevealSnapshot.call(session: time_travel_session.reload) }
      end

      def show
        render json: { reveal: ::Sportsbook::RevealSnapshot.call(session: time_travel_session) }
      end

      private

      def time_travel_session
        @time_travel_session ||= current_user.time_travel_sessions.find_by!(uuid: params[:time_travel_session_id])
      end

    end
  end
end
