# frozen_string_literal: true

class BaseEntryPoint

  include Authorizable

  def call
    authorize!
    validate_form!
    action.call
  end

  def self.call(*args, **kwargs)
    new(*args, **kwargs).call
  end

  private

  attr_accessor :action, :form

  def validate_form!
    return if form.blank?

    result = form.call
    raise_invalid_form_params_error(result) if result.failure?
  end

  def raise_invalid_form_params_error(result)
    raise Errors::InvalidFormParams, result.errors.to_h
  end

end
