# frozen_string_literal: true

class BettingOdds < ApplicationRecord

  belongs_to :match

  def odds_for(team)
    return home_team_win if match.home_team?(team)
    return away_team_win if match.away_team?(team)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[away_team_win created_at draw home_team_win id match_id updated_at]
  end

end
