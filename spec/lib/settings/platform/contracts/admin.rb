# frozen_string_literal: true

module Settings
  module Platform
    module Contracts
      class Admin < Dry::Validation::Contract

        schema do
          required(:show_profit_calculation_page).filled(:bool)
        end

      end
    end
  end
end
