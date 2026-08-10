# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, skip: :all
  ActiveAdmin.routes(self)

  namespace :admin do
    mount Sidekiq::Web => '/sidekiq'
    mount Flipper::UI.app(Flipper) => '/flipper'
  end

  mount Flipper::Api.app(Flipper) => '/flipper/api'

  get 'api/countries', action: :index, controller: 'api/countries'
  post 'api/countries', action: :create, controller: 'api/countries'
  put 'api/countries', action: :update, controller: 'api/countries'
  delete 'api/countries', action: :destroy, controller: 'api/countries'

  namespace :api do
    namespace :v1 do # rubocop:disable Naming/VariableNumber
      get 'auth/csrf', to: 'auth/csrf#show'
      post 'users', to: 'users#create'
      resource :session, only: %i[create destroy]
      resource :me, only: %i[show update], controller: 'me'
      get 'sportsbook/bootstrap', to: 'sportsbook#bootstrap'

      resources :time_travel_sessions, only: %i[index show create] do
        resources :wagers, only: :create, controller: 'time_travel_session_wagers'
        resource :reveal, only: %i[show create], controller: 'time_travel_reveals'
      end
      resources :wagers, only: :index
    end
  end
end
