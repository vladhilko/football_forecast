# frozen_string_literal: true

module Seasons
  module Authorizers
    class NotPopulated < BaseAuthorizer

      def authorize
        raise Errors::SeasonIsAlreadyPopulated, error_message if entry_point.season.completeness_status == 'full'
      end

      private

      def error_message
        "You can't populate the season that's already populated"
      end

    end
  end
end
