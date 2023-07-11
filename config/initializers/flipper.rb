# frozen_string_literal: true

require 'flipper/adapters/active_record'
require 'flipper/adapters/active_support_cache_store'

Rails.application.reloader.to_prepare do
  Flipper.configure do |config|
    config.adapter do
      if Rails.env.test?
        FeatureFlags::Adapters::MemoryBased.new
      else
        Flipper::Adapters::ActiveSupportCacheStore.new(
          FeatureFlags::Adapters::ActiveRecordBased.new,
          ActiveSupport::Cache::MemoryStore.new,
          expires_in: 5.minutes
        )
      end
    end
  end
end
