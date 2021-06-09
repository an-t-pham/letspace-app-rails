Rails.application.routes.draw do
  
  root 'sessions#welcome'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get  '/signup' => 'users#new'
  post '/logout' => 'sessions#destroy'
  
  get '/properties/search' => 'properties#search', :as =>'search_properties'

  get '/auth/google_oauth2/callback' => 'sessions#omniauth'

  patch '/landlord_or_tenant' => 'users#landlord_tenant'

  resources :users

  resources :tenants, only: [:show, :edit] do
    resources :properties, only: [:index] do
      resources :reviews, only: [:new, :edit, :update, :destroy, :show]
        post '/' => 'reviews#create'
        patch '/' => 'reviews#update'
        put '/' => 'reviews#update'
    end

    get '/properties/:id' => 'properties#tenant_property', :as => 'previous_property'
  end
  
  resources :landlords, only: [:show, :edit] do
    resources :properties, only: [:edit, :update, :new, :create, :destroy]
    get '/properties' => 'properties#landlord_properties', :as => 'properties_show'
    get '/properties/:id' => 'properties#landlord_property', :as => 'property_show'
  end

  resources :landlords, only: [:show, :edit, :update]

  resources :properties, only: [:index, :show]
   post '/properties' => 'properties#filter_properties', :as => 'filter_properties'
   
  

  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
