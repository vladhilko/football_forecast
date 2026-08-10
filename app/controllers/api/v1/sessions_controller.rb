# frozen_string_literal: true

module Api
  module V1
    class SessionsController < Api::V1::ApplicationController

      skip_before_action :require_player!, only: :create

      def create
        user = User.find_for_database_authentication(email: normalized_email)
        unless valid_credentials?(user)
          raise ::Sportsbook::Error.new('invalid_credentials', 'Email or password is incorrect', status: :unauthorized)
        end

        sign_in(:user, user)
        render json: { user: Serializer.user(user), wallet: Serializer.wallet(user.wallet) }
      end

      def destroy
        sign_out(:user)
        head :no_content
      end

      private

      def normalized_email
        params.require(:email).to_s.strip.downcase
      end

      def valid_credentials?(user)
        user&.valid_password?(params.require(:password)) && user.active_for_authentication?
      end

    end
  end
end
