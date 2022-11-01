# frozen_string_literal: true

class League < ApplicationRecord

  belongs_to :country

  has_many :seasons

end
