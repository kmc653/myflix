Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  #get '/videos/:title', to: 'videos#show', as: 'video'
  resources :videos, only: [:show] do
    collection do
      get :search, to:"videos#search"
    end
  end
  resources :users, only: [:create]
  get '/categories/:name', to: 'categories#show', as: 'category'
end
