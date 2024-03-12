# frozen_string_literal: true

class League < ApplicationRecord

  belongs_to :country

  has_many :seasons

  validates :name, uniqueness: { scope: :country_id, case_sensitive: false }

  def self.ransackable_attributes(_auth_object = nil)
    %w[country_id created_at id name updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[country seasons]
  end

end
