class CreateTemporaryDataEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :temporary_data_entries do |t|
      t.string :key, null: false
      t.json :data

      t.timestamps
      t.index :key, unique: true
    end
  end
end
