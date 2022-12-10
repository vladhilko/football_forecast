# frozen_string_literal: true

ActiveAdmin.register_page Constants.active_admin.pages.calculate_season_profit do
  belongs_to :season, parent_class: Season

  breadcrumb do
    [link_to('Admin', admin_root_path), link_to('Seasons', admin_seasons_path)]
  end

  page_action :calculate_season_profit, method: :post do
    season = Queries::Season.find_by(id: params['season_id'])

    profit = ActiveRecord::Base.transaction do
      Seasons::CalculateProfit::EntryPoint.call(
        season:,
        params: {
          team: params[:calculate_season_profit][:team],
          amount: params[:calculate_season_profit][:amount],
          bet_strategy: params[:calculate_season_profit][:bet_strategy]
        }
      )
    end

    redirect_to admin_season_path(season), notice: "Your profit is: #{profit}"
  end

  content do
    active_admin_form_for 'calculate_season_profit', html: { novalidate: false },
                                                     url: { action: :calculate_season_profit },
                                                     method: :post do |f|
      f.inputs name: 'Calculate Season Profit' do
        f.input :team, label: 'Team', required: true
        f.input :amount, label: 'Bet Amount', required: true
        f.input :bet_strategy, label: 'Bet Strategy', required: true, collection: ['always_win'], include_blank: false
      end
      f.actions do
        f.submit 'Calculate'
      end
    end
  end
end
