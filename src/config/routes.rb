Rails.application.routes.draw do
  get 'hello_world', to: 'hello_world#index'
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
  # Administrator's Dashboard
  get '/get_most_profitable_businesses', to: 'dashboards#get_most_profitable_businesses'
  # BusinessOwner's Dashboard
  get '/get_latest_businesses_orders', to: 'dashboards#get_latest_businesses_orders'
  get '/get_my_businesses', to: 'dashboards#get_my_businesses'

  #get '/sign_up_customer', to: 'customers#new'
  #post '/sign_up_customer', to: 'customers#create'
  #get '/sign_up_business_owner', to: 'business_owners#new'
  #Wpost '/sign_up_business_owner', to: 'business_owners#create'

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
  resources :businesses
  get '/get_business_statistics', to: 'businesses#get_business_statistics'

  resources :administrators, only: [:edit, :update]
  resources :business_owners, only: [:new, :create, :edit, :update, :destroy]
  resources :customers, only: [:new, :create, :edit, :update, :destroy]


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
