Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get '/', to: 'front#home'
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  resources :users, only: [:create]
  resources :videos, only: [:show] do
    collection do 
      get 'search', to: 'videos#search'
    end
  end
  resources :categories, only: [:show]
end
