# frozen_string_literal: true

ActiveAdmin.register Country do
  menu parent: 'Leagues'

  actions :index, :show

  config.batch_actions = false

  filter :id
  filter :name

  action_item :populate_matches, only: :show do
    link_to 'Populate All Initial Seasons', populate_matches_admin_country_path(resource), method: :post
  end

  member_action :populate_matches, method: :post do
    Countries::PopulateMatchesJob.perform_async(resource.id)

    redirect_to admin_country_path(resource), notice: 'All country leagues matches population has been started'
  end

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
