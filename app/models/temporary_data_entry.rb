# frozen_string_literal: true

class TemporaryDataEntry < ApplicationRecord

  attribute :key, :string
  attribute :data, :json

end
