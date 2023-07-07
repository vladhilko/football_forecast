class AddUuidToSeasons < ActiveRecord::Migration[7.0]
  def change
    change_table :seasons, bulk: true do |t|
      t.column :uuid, :string
      t.index :uuid, unique: true
    end
  end
end
