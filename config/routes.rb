Rails.application.routes.draw do
  
  root 'sessions#welcome'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get  '/signup' => 'users#new'
  post '/logout' => 'sessions#destroy'
  
  resources :users

  resources :tenants, only: [:show, :edit]
  
  resources :landlords, only: [:show] do
    resources :properties, only: [:edit, :update, :new, :create, :destroy]
    get '/properties' => 'properties#landlord_properties', :as => 'properties_show'
    get '/properties/:id' => 'properties#landlord_property', :as => 'property_show'
  end

  resources :landlords, only: [:show, :edit, :update]
  resources :properties, only: [:index, :show] do
    resources :reviews, only: [:new, :index]
  end
  

  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
