Myflix::Application.routes.draw do
  root 'pages#front'
  
  #mockup
  get 'ui(/:action)', controller: 'ui'

  #video
  get '/home', to: 'videos#index'
  
  resources :videos, only: [:show] do
    collection do 
      get 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

  # category
  resources :categories, only: [:show]

  # user
  get '/register', to: 'users#new'
  get '/register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  resources :users, only: [:create, :show]

  # session
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  delete '/sign_out', to: 'sessions#destroy'

  # queue item
  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'
  resources :queue_items, only: [:create, :destroy]
  
  # relationship
  get '/people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]

  #forgot password
  get '/forgot_password', to: 'forgot_passwords#new'
  get '/forgot_password_confirm', to: 'forgot_passwords#confirm'
  resources :forgot_passwords, only: [:create]

  #reset password
  get '/invalid_token', to: 'reset_passwords#invalid_token'
  resources :reset_passwords, only: [:show, :create]
  
  # invitation
  resources :invitations, only: [:new, :create]  
end
