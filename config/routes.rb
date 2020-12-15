Rails.application.routes.draw do
  root 'sessions#welcome'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get  '/signup' => 'users#new'
  post '/logout' => 'sessions#destroy'

  resources :reviews
  resources :tenants
  resources :properties
  resources :landlords
  resources :users

  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
