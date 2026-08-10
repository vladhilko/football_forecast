# frozen_string_literal: true

module Api
  module V1
    module Auth
      class CsrfController < Api::V1::ApplicationController

        skip_before_action :require_player!

        def show
          render json: { csrf_token: form_authenticity_token }
        end

      end
    end
  end
end
