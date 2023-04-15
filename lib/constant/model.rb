# frozen_string_literal: true

require 'forwardable'

module Constant
  class SymbolizedHashWithIndifferentAccess < HashWithIndifferentAccess

    private

    def convert_key(key)
      key.is_a?(String) ? key.to_sym : key
    end

  end

  class Model

    def initialize(init_hash = {})
      raise ArgumentError, 'initialized with wrong values' unless init_hash.is_a?(Hash)

      @hash_table = SymbolizedHashWithIndifferentAccess.new

      init_hash.each { |key, value| build_struct(key, value) }

      deep_freeze(hash_table)
    end

    # provides missing methods
    delegate_missing_to :hash_table

    private

    attr_reader :hash_table

    def build_struct(key, value)
      initialized_value = hash_table[key] = initialize_value(value)

      define_singleton_method(key) { initialized_value }
    end

    def initialize_value(value)
      case value
      when Hash then self.class.new(value)
      when Array then self.class.new(value.index_by(&:itself))
      else value
      end
    end

    def deep_freeze(hash)
      hash.freeze.each { |item| item.respond_to?(:each) ? deep_freeze(item) : item.freeze }
    end

  end
end
