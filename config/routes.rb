Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      # Authentication routes
      devise_for :users, controllers: {
        sessions: 'api/v1/sessions',
        registrations: 'api/v1/registrations'
      }

      # Dashboard routes
      get 'dashboard', to: 'dashboard#index'
      get 'dashboard/credits', to: 'dashboard#credit_status'

      # User rulesets (independent of projects)
      resources :rulesets, only: [:show, :update, :destroy] do
        member do
          post :create_version
          post :revert
          get :version_history
        end
        collection do
          get :user_index
        end
      end

      # Project routes
      resources :projects do
        member do
          post :generate_ruleset
        end
        resources :rulesets, only: [:index, :show, :create, :update, :destroy]
      end

      # Admin routes
      namespace :admin do
        get 'users', to: 'admin#users_overview'
        get 'users/:user_id', to: 'admin#user_details'
        post 'users/:user_id/grant_credits', to: 'admin#grant_credits'
        get 'users/:user_id/transactions', to: 'admin#credit_transactions'
        get 'stats', to: 'admin#system_stats'
      end

      # Public ruleset sharing
      get 'ruleset/:uuid', to: 'rulesets#show_public', as: :public_ruleset
    end
  end

  # Health check endpoint
  get '/health', to: 'application#health'
end
