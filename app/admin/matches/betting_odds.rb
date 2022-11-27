# frozen_string_literal: true

ActiveAdmin.register BettingOdds do
  menu parent: 'Matches'

  actions :index, :show

  config.batch_actions = false

  includes :match

  filter :id

  index do
    id_column
    column :home_team_win
    column :draw
    column :away_team_win
    column :match
  end

  show do
    attributes_table do
      row :id
      row :home_team_win
      row :draw
      row :away_team_win
      row :match
      row :created_at
      row :updated_at
    end
  end
end
