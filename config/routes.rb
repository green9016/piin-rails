# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  # Sidekiq routes
  mount Sidekiq::Web => '/sidekiq'
  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    [user, password] == [ENV['SIDEKIQ_USERNAME'], ENV['SIDEKIQ_PASSWORD']]
  end
  Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

  root to: 'application#index'

  # AUTH SCOPE
  mount_devise_token_auth_for 'Admin', at: 'admin', skip: [:registrations, :password]

  mount_devise_token_auth_for 'User', at: 'users', controllers: {
      sessions: 'v1/sessions',
      passwords: 'v1/passwords',
      registrations: 'v1/registrations'
  }

  mount_devise_token_auth_for 'Business', at: 'businesses', controllers: {
      registrations: 'v1/business_controllers/registrations',
      passwords: 'v1/business_controllers/passwords',
  }, skip: [:omniauth_callbacks]

  namespace :v1 do
    # USER SCOPE
    get 'feed', to: 'feed#index', as: :feed
    resources :flags
    resources :pins, only: [] do
      post :visit, on: :member
    end
    resources :posts, only: [:index, :show] do
      get :favorites, on: :collection

      member do
        post :like
        post :dislike
        delete :unfavorite
      end
    end
    resources :notifications, only: [] do
      resources :alerts, except: %i[index new edit]
    end
    resources :alerts, only: %i[index]
    resources :support_tickets, except: %i[new edit]
    resources :reports, except: %i[new edit]

    resources :users, only: [] do
      post :subscription, on: :collection
      post :charge, on: :collection
      post :pay, on: :collection
      get :purchase_history, on: :collection
      post :save_card_details, on: :collection
      get :payment_history, on: :collection
    end

    # ADMIN SCOPE
    scope path: :admin, module: :admin_controllers do
      resources :firms
      resources :users
      resources :businesses
      resources :posts
      resources :pins
      resources :features
      resources :notifications
      resources :pin_catalogs
      get '/unchecked_notification', to: 'notifications#unchecked_notification'
      resources :holidays
      resources :support_tickets
      resources :payments
      resources :dashboard, only: [] do
        get :stats, on: :collection
      end
      resources :reports, only: %i[index show update]
      resources :notifications, only: [] do
        resources :alerts
      end
      resources :offers
    end

    # BUSINESS SCOPE
    devise_scope :business do
      scope path: :business, module: :business_controllers do
        resources :pins, only: %i[index create destroy] do
          post :activate, on: :member
        end
        resources :pin_catalogs, only: %i[index]
        resources :posts, except: %i[new edit] do
          post :preview, on: :collection
        end
        resources :notifications, only: [] do
          resources :alerts
        end
        resources :alerts, only: [:index]
        resources :support_tickets, except: %i[new edit]
        resources :flags
        resources :trustees
        resources :firm_reports, only: %i[index] do
          get :current, on: :collection
        end
        resources :payments, only: [:index] do
          post :send_payments, on: :collection
        end
        resources :holidays, only: [:index]
        resources :features, only: [:index]
      end
    end
  end
end
