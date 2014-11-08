Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get '/videos/:title', to: 'videos#show', as: 'video'
  get '/categories/:name', to: 'categories#show', as: 'category'
end
