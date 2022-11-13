# frozen_string_literal: true

module Queries
  class League

    class << self

      def by_country(country)
        ::League.where(country:)
      end

    end

  end
end
