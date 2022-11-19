# frozen_string_literal: true

ActiveAdmin.register Country do
  actions :index, :show

  config.batch_actions = false

  filter :id
  filter :name

  index do
    id_column
    column :name
  end

  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
    end

    panel 'Leagues' do
      table_for resource.leagues do
        column :name do |league|
          link_to league.name, admin_league_path(league)
        end
      end
    end
  end
end
