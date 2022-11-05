# frozen_string_literal: true

ActiveAdmin.register Season do
  actions :index, :show

  config.batch_actions = false

  includes league: :country

  filter :league
  filter :league_country_id, as: :select, label: 'Country', collection: -> { Country.all.order(:name) }

  filter :id
  filter :name

  index do
    id_column
    column :name
    column :league
    column :country do |season|
      season.league.country
    end
  end

  show do
    attributes_table do
      row :id
      row :name
      row :league
      row :country do |season|
        season.league.country
      end
      row :created_at
      row :updated_at
    end
  end
end
