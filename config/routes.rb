Rails.application.routes.draw do
  root 'sessions#welcome'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get  '/signup' => 'users#new'
  post '/logout' => 'sessions#destroy'
  
  resources :users
  resources :reviews
  resources :tenants, only: [:show, :edit]
  
  resources :landlords, only: [:show] do
    resources :properties, only: [:edit, :update, :new]
    get '/properties' => 'properties#landlord_properties', :as => 'properties'
    get '/properties/:id' => 'properties#landlord_property', :as => 'property_show'
  end

  resources :landlords, only: [:show, :edit]
  resources :properties, only: [:index, :show]
  

  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
