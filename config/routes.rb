Rails.application.routes.draw do

  class OnlyAjaxRequest
     def matches?(request)
       request.xhr?
     end
   end

  # Rutas mediante AJAX
  get 'elements/show_ajax' => 'elements#show_ajax', constraint: OnlyAjaxRequest.new
  get 'movements/get_element_ajax' => 'movements#get_element_ajax', constraint: OnlyAjaxRequest.new

  get 'movements' => 'movements#index' , as: :movements
  get 'movements/enter'
  get 'movements/exit'
  get 'movements/edit'
  get 'movements/incomplete_bin'
  post 'movements/enter_element'
  post 'movements/exit_element'
  post 'movements/update'
  post 'movements/incomplete_bin_save'

  resources :user_control_accesses
  resources :ip_addresses
  # User Control routes
  get '/user_controls/sign_in', to: 'user_controls#new_session'
  post '/user_controls/create_session'
  delete '/user_controls/sign_out', to: 'user_controls#destroy_session'
  resources :user_controls, except: [:show] do
    member do
      post :add_access# => , as: :authorize_user
      post :remove_access# => , as: :authorize_user
    end
  end

  # post '/user_controls/:id/add_access', to: 'user_controls#add_access'
  # post '/user_controls/:id/remove_access', to: 'user_controls#remove_access'

  get 'reports/index', as: :reports
  get 'reports/warehouse_report'#, as: :reports
  get 'reports/show_downloads', as: :downloads
  get 'reports/download_s3_file', as: :download_s3_file
  get 'reports/process_products_xls', as: :process_products_xls


  get 'pages/home'
  get 'pages/home_quality_controls'

  # devise_for :users
  devise_for :users, :controllers => { :sessions => "users/sessions" }
  resources :users, only: [:show, :index, :edit, :update, :destroy] do
    member do
      post :authorize# => , as: :authorize_user
      post :change_role
    end
  end
  # post '/users/authorize' => 'general#accept_invoice', as: :authorize
  # resources :drying_methods
  # resources :product_types

  resources :elements_groups do
    member do
      post :add_element# => , as: :authorize_user
      post :remove_element
    end
  end

  get 'elements/elems_in_wh_and_quality', as: :elems_in_wh_and_quality
  resources :elements
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #get '/' => "elements#index"
  #get '/' => "pages#home_quality_controls"

  # resources :damage_samples
  # resources :caliber_samples
  # resources :carozo_samples
  resources :sorbate_samples
  resources :humidity_samples
  resources :group_humidity_samples



  namespace :calibrado do
    resources :caliber_samples
    resources :damage_samples
  end

  namespace :recepcion_seco do
    resources :caliber_samples
    resources :damage_samples
  end

  namespace :secado do
    resources :caliber_samples
    resources :damage_samples
  end

  namespace :seam do
    resources :caliber_samples
    resources :damage_samples
  end

  namespace :cn do
    resources :caliber_samples
    resources :damage_samples
  end

  namespace :tsc do
    resources :caliber_samples
    resources :damage_samples
    resources :carozo_samples
  end

  namespace :tcc do
    resources :caliber_samples
    resources :damage_samples
  end

  root "pages#home"

end
