Rails.application.routes.draw do
  post '/users', to: 'users#create'
  get "/users", to: 'users#index'
  get '/users/:id', to: 'users#show'

  post '/posts', to: 'posts#create'
  get 'posts/:id', to: 'posts#show'
  get '/posts', to: 'posts#index'
  patch 'posts/:id', to: 'posts#update'
  delete 'posts/:id', to: 'posts#destroy'


  post '/comments', to: 'comments#create'
  get '/comments', to: 'comments#index'
  get '/comments/:id', to: 'comments#show'
  patch '/comments/:id', to: 'comments#update'
  delete '/comments/:id', to: 'comments#destroy'
  # root "posts#index"
end
