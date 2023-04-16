# frozen_string_literal: true

Rails.application.config.after_initialize do
  Constant::Initialize.new(path: 'config/constants', constant_name: 'Constants').call
end
