# frozen_string_literal: true

module Api
  module V1
    class WagersController < Api::V1::ApplicationController

      def index
        wagers = current_user.wagers.includes(:time_travel_session_match).order(placed_at: :desc)
        render json: { wagers: wagers.map { Serializer.wager(_1, reveal_result: _1.status != 'pending') } }
      end

    end
  end
end
