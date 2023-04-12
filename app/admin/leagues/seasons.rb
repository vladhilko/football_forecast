# frozen_string_literal: true

ActiveAdmin.register Season do
  menu parent: 'Leagues'

  actions :index, :show

  config.batch_actions = false
  config.sort_order = 'name_desc'

  includes league: :country

  filter :league_country_id, as: :select, label: 'Country', collection: -> { Country.all.order(:name) }
  filter :league, as: :select, label: 'League',
                  collection: -> { Queries::League.by_country(params.dig(:q, :league_country_id_eq)) }

  filter :id
  filter :name
  filter :completeness_status, as: :select, collection: -> { Constants.season.completeness_statuses.values }

  action_item :calculate_season_profit, only: :show do
    link_to 'Calculate Season Profit', admin_season_calculate_season_profit_path(resource)
  end

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
      row 'Populated matches' do |season|
        matches = Queries::Match.by_season(season)
        view_all_params = { 'q[season_id_equals]': season.id, order: 'date_asc' }
        link_to "View all matches (#{matches.size})", admin_matches_path(view_all_params)
      end
    end
  end
end
