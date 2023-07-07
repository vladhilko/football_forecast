# frozen_string_literal: true

class Season < ApplicationRecord

  include UUID
  include PredicateMethods

  belongs_to :league

  has_many :matches

  validates :name, uniqueness: { scope: :league_id, case_sensitive: false }
  validates :completeness_status, inclusion: { in: Constants.season.completeness_statuses.values }

  define_predicate_methods attribute: :completeness_status,
                           available_values: Constants.season.completeness_statuses.values,
                           prefix: true

end
