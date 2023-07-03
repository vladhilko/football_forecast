# frozen_string_literal: true

RSpec.configure do |config|
  config.around(:example, :current_platform) do |example|
    ClimateControl.modify CURRENT_PLATFORM: example.metadata[:current_platform] do
      example.run
    end
  end
end
