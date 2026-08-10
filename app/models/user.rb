# frozen_string_literal: true

class User < ApplicationRecord

  include UUID

  STATUSES = %w[active suspended].freeze
  REVEAL_MODES = %w[honest synthetic].freeze

  devise :database_authenticatable, :validatable

  has_one :wallet, dependent: :destroy
  has_many :time_travel_sessions, dependent: :restrict_with_exception
  has_many :wagers, dependent: :restrict_with_exception

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :display_name, presence: true, length: { maximum: 80 }
  validates :status, inclusion: { in: STATUSES }
  validates :preferred_reveal_mode, inclusion: { in: REVEAL_MODES }

  def active_for_authentication?
    super && status == 'active'
  end

end
