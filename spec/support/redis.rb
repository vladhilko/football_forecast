# frozen_string_literal: true

require 'mock_redis'

RSpec.configure do |config|
  config.before do
    allow(Redis).to receive(:new).and_return(MockRedis.new)
  end
end
