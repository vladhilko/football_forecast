# frozen_string_literal: true

module Betting
  module PlaceBet
    class Form < ::Form

      params do
        required(:bet_amount).filled(:decimal)
        required(:team).filled(:string)
        required(:bet_type).filled(:string)
      end

    end
  end
end
