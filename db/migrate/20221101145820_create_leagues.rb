# frozen_string_literal: true

class CreateLeagues < ActiveRecord::Migration[7.0]
  def change
    create_table :leagues do |t|
      t.string :name, null: false
      t.references :country, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
