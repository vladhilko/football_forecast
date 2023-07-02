# frozen_string_literal: true

module Settings
  module Platform
    class Repository

      CONFIG_DIRECTORY = 'config/settings/platform'
      CONFIG_FILE_EXTENSION = '.yml'
      DEFAULT_PLATFORM = 'first_platform'

      class << self

        def load!
          load_files!
        end

        def current_platform
          ENV.fetch('CURRENT_PLATFORM', DEFAULT_PLATFORM)
        end

        private

        def load_files!
          all_platform_settings_config_files.each do |config_file_path|
            settings_content = YAML.load_file(config_file_path)

            define_platform_setting_methods(File.basename(config_file_path, CONFIG_FILE_EXTENSION), settings_content)
          end
        end

        def all_platform_settings_config_files
          Dir.glob(File.join(CONFIG_DIRECTORY, "*#{CONFIG_FILE_EXTENSION}"))
        end

        def define_platform_setting_methods(setting_name, settings_content)
          deep_freeze(settings_content)
          define_singleton_method(setting_name) { settings_content[current_platform] }
        end

        def deep_freeze(enum)
          enum.freeze.each { |item| item.respond_to?(:each) ? deep_freeze(item) : item.freeze }
        end

      end

    end
  end
end
