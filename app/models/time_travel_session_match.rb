# frozen_string_literal: true

class TimeTravelSessionMatch < ApplicationRecord

  include UUID

  belongs_to :time_travel_session, inverse_of: :session_matches
  belongs_to :source_match, class_name: 'Match'

  has_many :wagers, dependent: :restrict_with_exception

  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :home_team, :away_team, :kickoff_at, :kickoff_timezone, presence: true
  validates :home_odds, :draw_odds, :away_odds, numericality: { greater_than: 0 }
  validates :final_home_score, :final_away_score,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :snapshot_is_immutable, on: :update

  def final_selection
    return 'home' if final_home_score > final_away_score
    return 'away' if final_away_score > final_home_score

    'draw'
  end

  def odds_for(selection)
    { 'home' => home_odds, 'draw' => draw_odds, 'away' => away_odds }.fetch(selection)
  end

  private

  def snapshot_is_immutable
    errors.add(:base, 'historical round snapshots are immutable') if changes_to_save.except('updated_at').any?
  end

end
