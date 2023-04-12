# frozen_string_literal: true

class Form < Dry::Validation::Contract

  option :params

  def call
    super(params)
  end

  def attributes
    @attributes ||= call.values.data
  end

end
