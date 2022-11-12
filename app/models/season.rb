# frozen_string_literal: true

class Season < ApplicationRecord

  COMPLETENESS_STATUSES = %w[
    initial
    full
    partial
    ongoing
    empty
  ].freeze

  belongs_to :league

  has_many :matches

  validates :name, uniqueness: { scope: :league_id, case_sensitive: false }
  validates :completeness_status, inclusion: { in: Constants.season.completeness_statuses.values }

end
