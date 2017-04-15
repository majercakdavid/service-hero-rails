Rails.application.routes.draw do
  #devise_for :users
  devise_scope :users do
  end
  devise_for :users, path: '', :skip => [:password, :registrations],
             path_names: { sign_in: 'login', sign_out: 'logout' }

  # ROOT PAGE
  root 'static_pages#home'

  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  get '/dashboard', to: 'dashboards#index'
  get '/sign_up_customer', to: 'customers#new'
  post '/sign_up_customer', to: 'customers#create'
  get '/sign_up_business_owner', to: 'business_owners#new'
  post '/sign_up_business_owner', to: 'business_owners#create'

  get '/business_owners/invite_employee', to: 'business_owners#new_employee'
  post '/business_owners/invite_employee', to: 'business_owners#invite_employee'

  #resources :business_service_orders
  #resources :business_services
  #resources :orders
  #resources :services
  #resources :employees
  #resources :business_business_owners
  #resources :documents
  #resources :businesses
  #resources :addresses
  resources :administrators, only: [:edit, :update, :destroy]
  resources :business_owners, only: [:edit, :update, :destroy]
  resources :customers, only: [:edit, :update, :destroy]


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
