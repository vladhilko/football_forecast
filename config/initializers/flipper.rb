# frozen_string_literal: true

require 'flipper/adapters/active_record'
require 'flipper/adapters/active_support_cache_store'

Rails.application.reloader.to_prepare do
  Flipper.configure do |config|
    config.adapter do
      Flipper::Adapters::ActiveSupportCacheStore.new(
        Flipper::Adapters::ActiveRecord.new,
        ActiveSupport::Cache::MemoryStore.new,
        expires_in: 5.minutes
      )
    end
  end
end
