# frozen_string_literal: true

class Bet < ApplicationRecord

  attribute :bet_amount, :float
  attribute :payout_amount, :float
  attribute :odds, :float

  belongs_to :match

end
