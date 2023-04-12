# frozen_string_literal: true

class BettingOdds < ApplicationRecord

  belongs_to :match

  def odds_for(team)
    return home_team_win if match.home_team?(team)
    return away_team_win if match.away_team?(team)
  end

end
