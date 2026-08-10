# frozen_string_literal: true

module Api
  module V1
    class MeController < Api::V1::ApplicationController

      def show
        render json: payload
      end

      def update
        current_user.update!(params.require(:user).permit(:preferred_reveal_mode))
        render json: payload
      end

      private

      def payload
        { user: Serializer.user(current_user), wallet: Serializer.wallet(current_user.wallet) }
      end

    end
  end
end
