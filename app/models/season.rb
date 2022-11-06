# frozen_string_literal: true

class Season < ApplicationRecord

  belongs_to :league

  has_many :matches

  validates :name, uniqueness: { scope: :league_id, case_sensitive: false }

end
