Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "users#index" # Defines the root path route ("/")
  get 'users' => 'users#index', as: :users
  get 'users/:id' => 'users#show', as: :user
  get 'users/:user_id/posts' => 'posts#index', as: :user_posts
  get 'users/:user_id/posts/:id' => 'posts#show', as: :user_post

  resources :users, only: [:index, :show] do
    resources :posts, only: [:index, :show, :new, :create, :destroy] do
      resources :likes, only: [:create, :destroy]
      resources :comments, only: [:new, :create, :destroy]
    end
  end
end
