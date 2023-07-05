# frozen_string_literal: true

module Settings
  module Platform
    module Contracts
      class ProfitCalculation < Dry::Validation::Contract

        schema do
          required(:enabled).filled(:bool)
          required(:show_full_message).filled(:bool)
          required(:calculation_strategies).array(:string, included_in?: %w[gross_profit net_profit other])
        end

      end
    end
  end
end
