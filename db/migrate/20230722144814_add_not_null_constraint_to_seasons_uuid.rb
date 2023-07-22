class AddNotNullConstraintToSeasonsUUID < ActiveRecord::Migration[7.0]
  def change
    change_column :seasons, :uuid, :string, null: false
  end
end
