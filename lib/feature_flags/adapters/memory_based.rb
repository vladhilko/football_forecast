# frozen_string_literal: true

require 'flipper'

module FeatureFlags
  module Adapters
    class MemoryBased < Flipper::Adapters::Memory

      FeatureFlagNotSupportedError = Class.new(StandardError)
      FeatureFlagStillSupportedError = Class.new(StandardError)

      def add(feature)
        raise FeatureFlagNotSupportedError unless supported_feature_flag?(feature.name)

        super
      end

      def enable(feature, gate, thing)
        raise FeatureFlagNotSupportedError unless supported_feature_flag?(feature.name)

        super
      end

      def remove(feature)
        raise FeatureFlagStillSupportedError if supported_feature_flag?(feature.name)

        super
      end

      private

      def supported_feature_flag?(feature)
        FeatureFlag.supported?(feature)
      end

    end
  end
end
