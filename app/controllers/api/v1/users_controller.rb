# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::ApplicationController

      skip_before_action :require_player!

      def create
        user = ::Sportsbook::RegisterUser.call(user_params)
        sign_in(:user, user)
        render json: player_payload(user), status: :created
      end

      private

      def user_params
        params.require(:user).permit(:display_name, :email, :password, :password_confirmation)
      end

      def player_payload(user)
        { user: Serializer.user(user), wallet: Serializer.wallet(user.wallet) }
      end

    end
  end
end
