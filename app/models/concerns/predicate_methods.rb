# frozen_string_literal: true

module PredicateMethods
  extend ActiveSupport::Concern

  MethodAlreadyDefined = Class.new(ArgumentError)

  class_methods do
    def define_predicate_methods(attribute:, available_values:, prefix: false)
      available_values.each do |value|
        method_name = [(prefix ? "#{attribute}_" : ''), value, '?'].join.to_sym
        raise MethodAlreadyDefined, "#{method_name} already defined" if instance_methods.include?(method_name)

        define_method(method_name) do
          public_send(attribute) == value
        end
      end
    end
  end
end
