Myflix::Application.routes.draw do
  root 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  delete '/sign_out', to: 'sessions#destroy'
  get '/people', to: 'relationships#index'
  get '/forgot_password', to: 'forgot_passwords#new'
  get '/forgot_password_confirm', to: 'forgot_passwords#confirm'
  get '/invalid_token', to: 'reset_passwords#invalid_token'
  resources :reset_passwords, only: [:show, :create]
  resources :forgot_passwords, only: [:create]
  resources :relationships, only: [:create, :destroy]
  resources :users, only: [:create, :show]
  resources :videos, only: [:show] do
    collection do 
      get 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end
  resources :categories, only: [:show]
  get 'my_queue', to: 'queue_items#index'
  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'
end
