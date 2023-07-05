# frozen_string_literal: true

ActiveAdmin.register_page Constants.active_admin.pages.calculate_season_profit do
  belongs_to :season, parent_class: Season

  include Settings::Platform::Mixin[:profit_calculation]

  breadcrumb do
    [
      link_to('Admin', admin_root_path),
      link_to("Season: #{params['season_id']}", admin_season_path(params['season_id']))
    ]
  end

  page_action :calculate_season_profit, method: :post do
    season = Queries::Season.find_by(id: params['season_id'])

    profit = ActiveRecord::Base.transaction do
      Seasons::CalculateProfit::EntryPoint.call(
        season:,
        params: {
          team: params[:calculate_season_profit][:team],
          amount: params[:calculate_season_profit][:amount],
          betting_strategy: params[:calculate_season_profit][:betting_strategy]
        }
      )
    end

    redirect_to admin_season_calculate_season_profit_path(season), notice: "Your profit is: #{profit}"
  end

  content do
    if platform_profit_calculation.enabled?
      active_admin_form_for 'calculate_season_profit', html: { novalidate: false },
                                                       url: { action: :calculate_season_profit },
                                                       method: :post do |f|
        f.inputs name: 'Calculate Season Profit' do
          f.input :team, label: 'Team', required: true,
                         include_blank: false,
                         collection: Queries::Match.by_season(params['season_id']).uniq_teams

          f.input :amount, label: 'Bet Amount', required: true, input_html: { value: '100' }
          f.input :betting_strategy, label: 'Betting Strategy',
                                     required: true,
                                     collection: Constants.betting.strategies.values,
                                     include_blank: false
        end
        f.actions do
          f.submit 'Calculate'
        end
      end
    end
  end
end
