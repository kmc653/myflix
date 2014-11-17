Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  get '/sign_out', to: 'sessions#destroy'
  get '/categories/:name', to: 'categories#show', as: 'category'
  #get '/videos/:title', to: 'videos#show', as: 'video'
  
  resources :videos, only: [:show] do
    collection do
      get :search, to:"videos#search"
    end
    resources :reviews, only: [:create]
  end
  resources :users, only: [:create]
  resources :sessions, only: [:create]
  
end
