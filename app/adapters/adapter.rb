# frozen_string_literal: true

module Adapter
  class << self

    def method_missing(method, *args, &block)
      Rails.application.config.public_send("#{method}_adapter")
    rescue NameError
      super
    end

  end
end
