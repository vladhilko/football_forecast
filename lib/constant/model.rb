# frozen_string_literal: true

module Constant
  class Model

    def initialize(constant_hash = {})
      @constant_hash = constant_hash.deep_symbolize_keys.freeze
    end

    def deep_transform
      tap { constant_hash.each { |key, value| define_singleton_method(key) { initialize_value(value) } } }
    end

    # provides missing methods ( for example '.values' etc. )
    delegate_missing_to :constant_hash

    private

    attr_reader :constant_hash

    def initialize_value(value)
      case value
      when Hash then Model.new(value).deep_transform
      when Array then initialize_array_values(value)
      else value.freeze
      end
    end

    def initialize_array_values(array)
      return array if array.all?(Hash)

      Model.new(array.index_by(&:itself)).deep_transform
    end

  end
end
