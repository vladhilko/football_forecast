# frozen_string_literal: true

module Authorizable
  extend ActiveSupport::Concern

  included do
    class_attribute :authorizer
  end

  class_methods do
    def authorize(authorizer_name)
      self.authorizer = authorizer_name
    end
  end

  def authorize!
    return if authorizer.blank?

    authorizer.to_s.classify.constantize.new(self).authorize
  end
end
