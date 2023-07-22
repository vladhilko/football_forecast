# frozen_string_literal: true

class BackfillUUIDForSeason < ActiveRecord::Migration[7.0]
  def up
    Season.where(uuid: nil).find_each do |season|
      season.update(uuid: SecureRandom.uuid)
    end
  end

  def down
  end
end
