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

  def self.ransackable_attributes(_auth_object = nil)
    %w[completeness_status created_at id league_id name populated_at updated_at uuid]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[league matches]
  end

end
