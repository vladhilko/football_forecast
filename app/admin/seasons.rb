# frozen_string_literal: true

ActiveAdmin.register Season do
  actions :index, :show

  config.batch_actions = false

  includes league: :country

  filter :league
  filter :league_country_id, as: :select, label: 'Country', collection: -> { Country.all.order(:name) }

  filter :id
  filter :name
  filter :completeness_status, as: :select, collection: -> { Season::COMPLETENESS_STATUSES }

  index do
    id_column
    column :name
    column :completeness_status do |season|
      status_tag season.completeness_status
    end
    column :league
    column :country do |season|
      season.league.country
    end
  end

  show do
    attributes_table do
      row :id
      row :name
      row :completeness_status do |season|
        status_tag season.completeness_status
      end
      row :populated_at
      row :league
      row :country do |season|
        season.league.country
      end
      row :created_at
      row :updated_at
    end
  end
end
