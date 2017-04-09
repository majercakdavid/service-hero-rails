Rails.application.routes.draw do
  #devise_for :users
  devise_scope :user do
    get '/sign_in', to: 'devise/sessions#new'
    delete '/sign_out', to: 'devise/sessions#destroy'
    get '/sign_up_administrators', to: 'users/registrations#new', :role => Administrator.name
    #post '/sign_up_administrators', to: 'users/registrations#create', :role => Administrator.name
    get '/sign_up_customers', to: 'users/registrations#new', :role => Customer.name
    #post '/sign_up_customers', to: 'users/registrations#create', :role => Customer.name
    get '/sign_up_business_owners', to: 'users/registrations#new', :role => BusinessOwner.name
    #post '/sign_up_business_owners', to: 'users/registrations#create', :role => BusinessOwner.name
  end
  devise_for :users, :path => '', :path_names => { :sign_in => 'sign_in', :sign_out => 'sign_out', :sign_up => 'register' }, controllers: {
      registrations: 'users/registrations'
  }

  # ROOT PAGE
  root 'static_pages#home'

  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  get '/dashboard', to: 'dashboards#index'

  #resources :business_service_orders
  #resources :business_services
  #resources :orders
  #resources :customers
  #resources :services
  #resources :employees
  #resources :business_business_owners
  #resources :business_owners
  #resources :documents
  #resources :businesses
  #resources :addresses
  #resources :administrators


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
