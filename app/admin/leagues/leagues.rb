# frozen_string_literal: true

ActiveAdmin.register League do
  menu parent: 'Leagues', label: 'League details'

  actions :index, :show

  config.batch_actions = false

  includes :country

  filter :id
  filter :name
  filter :country

  index do
    id_column
    column :name
    column :country
  end

  show do
    attributes_table do
      row :id
      row :name
      row :country
      row :created_at
      row :updated_at
    end

    panel 'Seasons' do
      table_for resource.seasons do
        column :name do |season|
          link_to season.name, admin_season_path(season)
        end
      end
    end
  end
end
