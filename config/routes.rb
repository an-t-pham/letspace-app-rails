Rails.application.routes.draw do
  resources :reviews
  resources :previous_records
  resources :tenants
  resources :properties
  resources :landlords

  root 'sessions#welcome'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
