class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.references :season, null: false, foreign_key: true, index: false
      t.date :date, null: false
      t.time :time
      t.string :home_team, null: false
      t.string :away_team, null: false
      t.string :score, null: false

      t.timestamps

      t.index [:season_id, :home_team, :away_team, :date], unique: true
    end
  end
end
