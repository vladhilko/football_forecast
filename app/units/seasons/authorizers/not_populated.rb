# frozen_string_literal: true

module Seasons
  module Authorizers
    class NotPopulated < BaseAuthorizer

      def authorize
        raise Errors::SeasonIsAlreadyPopulated, error_message if completeness_status_full?
      end

      private

      def completeness_status_full?
        entry_point.season.completeness_status == Constants.season.completeness_statuses.full
      end

      def error_message
        "You can't populate the season that's already populated"
      end

    end
  end
end
