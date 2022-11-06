# frozen_string_literal: true

module Errors
  class InvalidInputsParams < StandardError

    delegate :to_s, to: :errors

    def initialize(errors = {})
      @errors = errors
    end

    attr_reader :errors

  end
end
