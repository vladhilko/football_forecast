# frozen_string_literal: true

module Settings
  module Platform
    class Repository

      CONFIG_DIRECTORY = 'config/settings/platform'
      CONFIG_FILE_EXTENSION = '.yml'
      DEFAULT_PLATFORM = 'first_platform'

      class << self

        def load!
          all_platform_settings_config_files.each do |file_path|
            define_platform_setting_method(
              method_name: File.basename(file_path, CONFIG_FILE_EXTENSION),
              content: YAML.load_file(file_path)
            )
          end
        end

        def current_platform
          ENV.fetch('CURRENT_PLATFORM', DEFAULT_PLATFORM)
        end

        private

        def all_platform_settings_config_files
          Dir.glob(File.join(CONFIG_DIRECTORY, "*#{CONFIG_FILE_EXTENSION}"))
        end

        def define_platform_setting_method(method_name:, content:)
          deep_freeze(content)
          define_singleton_method(method_name) { content[current_platform] }
        end

        def deep_freeze(enum)
          enum.freeze.each { |item| item.respond_to?(:each) ? deep_freeze(item) : item.freeze }
        end

      end

    end
  end
end
