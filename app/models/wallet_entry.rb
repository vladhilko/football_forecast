# frozen_string_literal: true

class WalletEntry < ApplicationRecord

  ENTRY_TYPES = %w[opening_credit stake_debit payout_credit refund_credit].freeze

  belongs_to :wallet
  belongs_to :wager, optional: true

  validates :entry_type, inclusion: { in: ENTRY_TYPES }
  validates :amount_minor, :balance_after_minor, numericality: { only_integer: true }
  validates :idempotency_key, presence: true, uniqueness: true

  before_update :prevent_mutation
  before_destroy :prevent_mutation

  private

  def prevent_mutation
    errors.add(:base, 'wallet entries are immutable')
    throw :abort
  end

end
