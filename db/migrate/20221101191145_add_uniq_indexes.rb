# frozen_string_literal: true

class AddUniqIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :countries, :name, unique: true
    add_index :leagues, %i[country_id name], unique: true
    add_index :seasons, %i[league_id name], unique: true

    remove_index :leagues, column: [:country_id], name: 'index_leagues_on_country_id'
    remove_index :seasons, column: [:league_id], name: 'index_seasons_on_league_id'
  end
end
