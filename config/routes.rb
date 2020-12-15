Rails.application.routes.draw do

  get '/landlords/welcome' => 'landlords#welcome', :as => 'landlord_welcome'
  get '/tenants/welcome' => 'tenants#welcome', :as => 'tenant_welcome'
  resources :reviews
  resources :tenants
  resources :properties
  resources :landlords

  root 'sessions#welcome'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
