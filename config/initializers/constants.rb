# frozen_string_literal: true

Rails.application.config.after_initialize do
  Constant::Initialize.new('config/constants').call
end
