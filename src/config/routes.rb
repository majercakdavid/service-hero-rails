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
  get '/latest_businesses_orders', to: 'dashboards#latest_businesses_orders'

  get '/sign_up_customer', to: 'customers#new'
  post '/sign_up_customer', to: 'customers#create'
  get '/sign_up_business_owner', to: 'business_owners#new'
  post '/sign_up_business_owner', to: 'business_owners#create'

  get '/business_owners/invite_employee', to: 'business_owners#new_employee'
  post '/business_owners/invite_employee', to: 'business_owners#invite_employee'

  get '/employees/register', to: 'employees#new'
  post '/employees/register', to: 'employees#create'

  #resources :business_service_orders
  #resources :business_services
  #resources :orders
  #resources :services
  #resources :employees
  #resources :business_business_owners
  #resources :documents
  #resources :addresses
  resources :businesses, only: [:new, :edit, :update, :destroy]
  resources :administrators, only: [:edit, :update]
  resources :business_owners, only: [:edit, :update, :destroy]
  resources :customers, only: [:edit, :update, :destroy]


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
