Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  get '/sign_out', to: 'sessions#destroy'
  get '/categories/:name', to: 'categories#show', as: 'category'
  get '/my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'
  #get '/videos/:title', to: 'videos#show', as: 'video'
  
  resources :videos, only: [:show] do
    collection do
      get :search, to:"videos#search"
    end
    resources :reviews, only: [:create]
  end
  resources :users, only: [:create, :show]
  resources :sessions, only: [:create]
  resources :queue_items, only: [:create, :destroy]

end
