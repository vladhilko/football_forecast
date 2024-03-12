# frozen_string_literal: true

module Seasons
  module Decorators
    class Season < Draper::Decorator

      delegate_all

      def active?
        season_is_ongoing?
      end

      private

      def season_is_ongoing?
        if take_place_within_one_year?
          (Date.new(name.to_i).beginning_of_year..Date.new(name.to_i).end_of_year).include? Date.current
        elsif take_place_within_two_years?
          first_year, second_year = season_years.map { Date.new(_1.to_i) }
          (first_year..second_year).include?(Date.current)
        end
      end

      def take_place_within_one_year?
        season_years.size == 1
      end

      def take_place_within_two_years?
        season_years.size == 2
      end

      def season_years
        @season_years ||= name.split('/')
      end

    end
  end
end
