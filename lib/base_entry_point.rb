# frozen_string_literal: true

class BaseEntryPoint

  def call
    validate_inputs!
    action.call
  end

  def self.call(*args, **kwargs)
    new(*args, **kwargs).call
  end

  private

  attr_accessor :action, :inputs

  def validate_inputs!
    return if inputs.blank?

    result = inputs.call
    raise_invalid_inputs_params_error(result) if result.failure?
  end

  def raise_invalid_inputs_params_error(result)
    raise Errors::InvalidInputsParams, result.errors.to_h
  end

end
