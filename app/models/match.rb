# frozen_string_literal: true

class Match < ApplicationRecord

  belongs_to :season

  has_one :betting_odds

  validates :home_team, uniqueness: { scope: %i[season_id away_team date], case_sensitive: false }

  def name
    "#{home_team} - #{away_team}"
  end

  def result
    return Constants.match.results.home_team_win if home_team_score > away_team_score
    return Constants.match.results.away_team_win if away_team_score > home_team_score

    Constants.match.results.draw
  end

  def home_team?(team)
    home_team == team
  end

  private

  def home_team_score
    score.split(':').map(&:to_i).first
  end

  def away_team_score
    score.split(':').map(&:to_i).second
  end

end
