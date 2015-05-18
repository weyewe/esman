Ticketie::Application.routes.draw do
  devise_for :users
  root :to => 'home#index'
  
  
  namespace :api do
    devise_for :users
    post 'authenticate_auth_token', :to => 'sessions#authenticate_auth_token', :as => :authenticate_auth_token 
    put 'update_password' , :to => "passwords#update" , :as => :update_password
    get 'search_role' => 'roles#search', :as => :search_role, :method => :get
    get 'search_user' => 'app_users#search', :as => :search_user, :method => :get
    get 'search_item_type' => 'item_types#search', :as => :search_item_type, :method => :get
    get 'search_item' => 'items#search', :as => :search_item, :method => :get
    get 'search_customer' => 'customers#search', :as => :search_customer, :method => :get
    
    get 'work_customer_reports' => 'maintenances#customer_reports', :as => :work_customer_reports
    
    # master data 
    resources :app_users
    resources :customers 
    resources :item_types  
    resources :items 
    
    resources :maintenances
    
    
  end
  
  
end
