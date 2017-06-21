Rails.application.routes.draw do
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
  get '/get_business_services', to: 'business_services#get_business_services'
  #Customer's Dashboard
  get '/filtered_business_services', to: 'dashboards#filtered_business_services'

  # Manage time slots
  get '/time_slottable_business_services', to: 'time_slots#time_slottable_business_services'
  get '/business_service_time_slots', to: 'time_slots#business_service_time_slots'
  post '/business_service_time_slot', to: 'time_slots#create_business_service_time_slot'
  put '/business_service_time_slot', to: 'time_slots#update_business_service_time_slot'
  delete '/business_service_time_slot', to: 'time_slots#destroy_business_service_time_slot'
  put '/make_time_slot_reservation', to: 'time_slots#make_time_slot_reservation'
  #get '/sign_up_customer', to: 'customers#new'
  #post '/sign_up_customer', to: 'customers#create'
  #get '/sign_up_business_owner', to: 'business_owners#new'
  #Wpost '/sign_up_business_owner', to: 'business_owners#create'

  get '/business_owners/invite_employee', to: 'business_owners#new_employee'
  post '/business_owners/invite_employee', to: 'business_owners#invite_employee'

  get '/employees/register', to: 'employees#new'
  post '/employees/register', to: 'employees#create'

  #resources :business_service_orders
  #resources :orders
  #resources :services
  #resources :employees
  #resources :business_business_owners
  #resources :documents
  #resources :addresses
  resources :businesses
  get '/get_business_statistics', to: 'businesses#get_business_statistics'
  get '/businesses_services', to: 'business_services#index'

  resources :administrators, only: [:edit, :update]
  resources :business_owners, only: [:new, :create, :edit, :update, :destroy]
  resources :business_services, only: [:new, :create, :edit, :update, :destroy]
  resources :business_services do
    get :autocomplete_service_label, :on => :collection
  end
  resources :customers, only: [:new, :create, :edit, :update, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
