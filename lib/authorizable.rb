# frozen_string_literal: true

module Authorizable
  extend ActiveSupport::Concern

  included do
    class_attribute :authorizers, default: []
  end

  class_methods do
    def authorize(authorizer_name)
      self.authorizers += [authorizer_name]
    end
  end

  def authorize!
    authorizers.each do |authorizer|
      authorizer.to_s.classify.constantize.new(self).authorize
    end
  end
end
