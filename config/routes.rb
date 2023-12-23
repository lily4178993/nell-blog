Rails.application.routes.draw do
  devise_for :users
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "users#index" # Defines the root path route ("/")

  # The following routes are for the API.
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index] do
        resources :posts, only: [:index] do
          resources :comments, only: [:index, :create]
        end
      end
    end
  end
  # api/v1/users
  # api/v1/users/:id
  # api/v1/users/:id/posts
  # api/v1/users/:id/posts/:id
  # api/v1/users/:id/posts/:id/comments

  # The following routes are for the web app.
  resources :users, only: [:index, :show] do
    resources :posts, only: [:index, :show, :new, :create, :destroy] do
      resources :likes, only: [:create, :destroy]
      resources :comments, only: [:new, :create, :destroy]
    end
  end
end
