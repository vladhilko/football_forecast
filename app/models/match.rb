# frozen_string_literal: true

class Match < ApplicationRecord

  belongs_to :season

  validates :home_team, uniqueness: { scope: %i[season_id away_team date], case_sensitive: false }

end
