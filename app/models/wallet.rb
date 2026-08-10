# frozen_string_literal: true

class Wallet < ApplicationRecord

  belongs_to :user

  has_many :wallet_entries, dependent: :restrict_with_exception

  validates :currency, inclusion: { in: %w[PLAY] }
  validates :balance_minor, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

end
