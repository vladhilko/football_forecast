class AddCompletenessStatusToSeasons < ActiveRecord::Migration[7.0]
  def change
    add_column :seasons, :completeness_status, :string, null: false, default: 'initial'
  end
end
