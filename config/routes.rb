Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get '/videos/:id', to: 'videos#show', as: 'video'
  # resources :videos, only: [:show]
  # get 'videos(/:action(/:id))', controller: 'videos'
  # get ':controller(/:action(/:id))'
end
