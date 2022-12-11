# frozen_string_literal: true

module Seasons
  module CalculateProfit
    class Form < ::Inputs

      params do
        required(:amount).filled(:decimal)
        required(:team).filled(:string)
        required(:betting_strategy).filled(:string)
      end

    end
  end
end
