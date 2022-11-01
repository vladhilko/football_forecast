# frozen_string_literal: true

class Season < ApplicationRecord

  belongs_to :league

  validates :name, uniqueness: { scope: :league_id, case_sensitive: false }

end
