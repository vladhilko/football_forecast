# frozen_string_literal: true

require 'flipper'

module FeatureFlags
  module Adapters
    class ActiveRecordBased < Flipper::Adapters::ActiveRecord

      def add(feature)
        return false unless supported_feature_flag?(feature.name)

        super
      end

      def enable(feature, gate, thing)
        return false unless supported_feature_flag?(feature.name)

        super
      end

      def remove(feature)
        return false if supported_feature_flag?(feature.name)

        super
      end

      private

      def supported_feature_flag?(feature)
        FeatureFlag.supported?(feature)
      end

    end
  end
end
