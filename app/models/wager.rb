# frozen_string_literal: true

class Wager < ApplicationRecord

  include UUID

  SELECTIONS = %w[home draw away].freeze
  STATUSES = %w[pending won lost refunded].freeze
  CONFIRMED_ATTRIBUTES = %w[
    user_id time_travel_session_id time_travel_session_match_id source_match_id placement_key selection
    stake_minor decimal_odds potential_payout_minor placed_at
  ].freeze

  belongs_to :user
  belongs_to :time_travel_session
  belongs_to :time_travel_session_match
  belongs_to :source_match, class_name: 'Match'

  has_many :wallet_entries, dependent: :restrict_with_exception

  validates :selection, inclusion: { in: SELECTIONS }
  validates :status, inclusion: { in: STATUSES }
  validates :placement_key, presence: true
  validates :stake_minor, numericality: { only_integer: true, greater_than_or_equal_to: 100 }
  validates :potential_payout_minor, :payout_minor,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :decimal_odds, numericality: { greater_than: 0 }
  validates :source_match_id, uniqueness: { scope: :user_id }
  validate :confirmed_attributes_are_immutable, on: :update

  private

  def confirmed_attributes_are_immutable
    return if CONFIRMED_ATTRIBUTES.none? { will_save_change_to_attribute?(_1) }

    errors.add(:base, 'confirmed wagers are immutable')
  end

end
