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

      # Project routes
      resources :projects do
        member do
          post :generate_ruleset
        end
        resources :rulesets, only: [:index, :show, :create, :update, :destroy]
      end

      # Public ruleset sharing
      get 'ruleset/:uuid', to: 'rulesets#show_public', as: :public_ruleset
    end
  end

  # Health check endpoint
  get '/health', to: 'application#health'
end
