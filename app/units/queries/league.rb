# frozen_string_literal: true

module Queries
  class League < Query

    set_model ::League

    module Scopes
      def by_country(country)
        where(country:)
      end
    end

  end
end
