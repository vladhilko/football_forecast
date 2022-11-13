class AddPopulatedAtToSeasons < ActiveRecord::Migration[7.0]
  def change
    add_column :seasons, :populated_at, :datetime
  end
end
