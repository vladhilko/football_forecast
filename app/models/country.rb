# frozen_string_literal: true

class Country < ApplicationRecord

  has_many :leagues

  validates :name, uniqueness: { case_sensitive: false }

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id name updated_at]
  end

end
