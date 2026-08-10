# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::Base

      protect_from_forgery with: :exception

      before_action :require_player!

      rescue_from ::Sportsbook::Error, with: :render_sportsbook_error
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
      rescue_from ActionController::ParameterMissing, with: :render_parameter_missing
      rescue_from ActionController::InvalidAuthenticityToken, with: :render_invalid_csrf

      private

      def require_player!
        return if user_signed_in?

        render_error('authentication_required', 'Sign in to continue', status: :unauthorized)
      end

      def render_sportsbook_error(error)
        render_error(error.code, error.message, status: error.status, details: error.details)
      end

      def render_not_found
        render_error('not_found', 'The requested resource was not found', status: :not_found)
      end

      def render_record_invalid(error)
        render_error('validation_failed', 'The submitted data is invalid',
                     status: :unprocessable_entity, details: error.record.errors.to_hash)
      end

      def render_parameter_missing(error)
        render_error('parameter_missing', error.message, status: :bad_request)
      end

      def render_invalid_csrf
        render_error('invalid_csrf', 'The security token expired; refresh and try again', status: :unprocessable_entity)
      end

      def render_error(code, message, status:, details: nil)
        body = { error: { code:, message: } }
        body[:error][:fields] = details if details.present?
        render json: body, status:
      end

    end
  end
end
