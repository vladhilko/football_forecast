# frozen_string_literal: true

ActiveAdmin.register Match do
  actions :index, :show

  config.batch_actions = false

  includes season: :league

  filter :season
  filter :season_league_id, as: :select, label: 'League', collection: -> { League.all.order(:name) }

  filter :id
  filter :name

  index do
    id_column
    column :home_team
    column :away_team
    column :score
    column :date
    column :time do |match|
      match.time&.strftime('%H:%M')
    end
    column :season
    column :league do |match|
      match.season.league
    end
  end

  show do
    attributes_table do
      row :id
      row :home_team
      row :away_team
      row :score
      row :date
      row :time do |match|
        match.time&.strftime('%H:%M')
      end
      row :season
      row :league do |match|
        match.season.league
      end
      row :created_at
      row :updated_at
    end
  end
end
