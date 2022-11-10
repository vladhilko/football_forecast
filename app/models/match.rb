# frozen_string_literal: true

class Match < ApplicationRecord

  belongs_to :season

  has_one :betting_odds

  validates :home_team, uniqueness: { scope: %i[season_id away_team date], case_sensitive: false }

  def name
    "#{home_team} - #{away_team}"
  end

end
