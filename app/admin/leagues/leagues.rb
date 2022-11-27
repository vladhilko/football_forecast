# frozen_string_literal: true

ActiveAdmin.register League do
  menu parent: 'Leagues', label: 'League details'

  actions :index, :show

  config.batch_actions = false

  includes :country

  filter :id
  filter :name
  filter :country

  action_item :populate_matches, only: :show do
    link_to 'Populate All Initial Seasons', populate_matches_admin_league_path(resource), method: :post
  end

  member_action :populate_matches, method: :post do
    ActiveRecord::Base.transaction { Leagues::PopulateMatches::EntryPoint.call(league: resource) }

    redirect_to admin_season_path(resource), notice: 'All league matches population has been completed'
  end

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

        column :completeness_status do |season|
          status_tag season.completeness_status
        end
      end
    end
  end
end
