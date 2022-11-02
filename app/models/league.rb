# frozen_string_literal: true

class League < ApplicationRecord

  belongs_to :country

  has_many :seasons

  validates :name, uniqueness: { scope: :country_id, case_sensitive: false }

end
