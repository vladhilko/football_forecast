# frozen_string_literal: true

ActiveAdmin.register Season do
  actions :index, :show

  config.batch_actions = false

  includes league: :country

  filter :league
  filter :league_country_id, as: :select, label: 'Country', collection: -> { Country.all.order(:name) }

  filter :id
  filter :name
  filter :completeness_status, as: :select, collection: -> { Constants.season.completeness_statuses.values }

  action_item :populate_matches, only: :show do
    link_to 'Populate Matches', populate_matches_admin_season_path(resource), method: :post
  end

  member_action :populate_matches, method: :post do
    ActiveRecord::Base.transaction { Seasons::PopulateMatches::EntryPoint.call(season: resource) }

    redirect_to admin_season_path(resource), notice: 'Season matches population has been completed'
  rescue Errors::SeasonIsAlreadyPopulated => e
    redirect_to admin_season_path(resource), alert: e.message
  end

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
