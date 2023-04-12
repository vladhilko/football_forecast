class CreateBets < ActiveRecord::Migration[7.0]
  def change
    create_table :bets do |t|
      t.references :match, null: false, foreign_key: true, index: true
      t.decimal :bet_amount, scale: 2, precision: 10, null: false
      t.decimal :payout_amount, scale: 2, precision: 10, null: false, default: 0
      t.decimal :odds, scale: 2, precision: 10, null: false
      t.string :team
      t.string :bet_type, null: false
      t.string :status, null: false, default: 'pending'
      t.string :result

      t.timestamps
    end
  end
end
