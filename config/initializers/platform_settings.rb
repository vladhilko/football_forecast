# frozen_string_literal: true

require 'settings/platform/repository'

Rails.application.config.before_initialize do
  Settings::Platform::Repository.load!
end
