# frozen_string_literal: true

class CreateSeasons < ActiveRecord::Migration[7.0]

  def change
    create_table :seasons do |t|
      t.string :name, null: false
      t.references :league, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end

end
