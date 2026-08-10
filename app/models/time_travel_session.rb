# frozen_string_literal: true

class TimeTravelSession < ApplicationRecord

  include UUID

  REVEAL_DURATION = 45.seconds
  STATUSES = %w[betting revealing settled].freeze

  belongs_to :user
  belongs_to :league

  has_many :session_matches,
           -> { order(:position) },
           class_name: 'TimeTravelSessionMatch',
           dependent: :destroy,
           inverse_of: :time_travel_session
  has_many :wagers, dependent: :restrict_with_exception

  validates :travel_on, :round_fingerprint, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :reveal_mode, inclusion: { in: User::REVEAL_MODES }
  validates :round_fingerprint, uniqueness: { scope: :user_id }

  def reveal_deadline
    reveal_started_at && reveal_started_at + REVEAL_DURATION
  end

  def reveal_elapsed(now = Time.current)
    return 0.0 unless reveal_started_at

    [[now - reveal_started_at, 0].max, REVEAL_DURATION.to_f].min
  end

end
