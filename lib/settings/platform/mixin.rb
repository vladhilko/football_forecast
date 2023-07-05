# frozen_string_literal: true

module Settings
  module Platform
    module Mixin
      def self.[](name) # rubocop:disable Metrics/MethodLength
        Module.new do
          define_method "platform_#{name}".to_sym do
            PlatformStruct.new(name)
          end

          define_singleton_method :included do |base|
            return unless active_admin?(base)

            base.controller.prepend self
            base.controller.helper_method "platform_#{name}"
          end

          def self.active_admin?(base)
            base.is_a?(ActiveAdmin::DSL)
          end
        end
      end

      class PlatformStruct < SimpleDelegator

        def initialize(name)
          super(Settings::Platform::Repository.public_send(name))

          generate_methods
        end

        private

        def generate_methods
          keys.each do |key|
            define_singleton_method(key) { self[key] }
            define_singleton_method("#{key}?") { self[key] }
          end
        end

      end
    end
  end
end
