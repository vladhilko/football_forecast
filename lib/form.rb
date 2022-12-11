# frozen_string_literal: true

class Form < Dry::Validation::Contract

  option :params

  def call
    super(params).tap do |result|
      self.attributes = result.values
    end
  end

  attr_reader :attributes

  private

  attr_writer :attributes

end
