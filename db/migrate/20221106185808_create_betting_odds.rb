class CreateBettingOdds < ActiveRecord::Migration[7.0]
  def change
    create_table :betting_odds do |t|
      t.references :match, null: false, foreign_key: true, index: true
      t.decimal :home_team_win, scale: 2, precision: 10, null: false
      t.decimal :away_team_win, scale: 2, precision: 10, null: false
      t.decimal :draw, scale: 2, precision: 10, null: false

      t.timestamps
    end
  end
end
