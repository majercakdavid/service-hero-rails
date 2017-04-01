Rails.application.routes.draw do

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

  resources :business_service_orders
  resources :business_services
  resources :orders
  resources :customers
  resources :services
  resources :employees
  resources :business_business_owners
  resources :business_owners
  resources :documents
  resources :businesses
  resources :addresses
  resources :administrators
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
