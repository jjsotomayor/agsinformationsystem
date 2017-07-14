Rails.application.routes.draw do
  resources :damage_samples
  resources :carozo_samples
  resources :ip_addresses
  # User Control routes
  get '/user_controls/sign_in', to: 'user_controls#new_session'
  post '/user_controls/create_session'
  delete '/user_controls/sign_out', to: 'user_controls#destroy_session'
  resources :user_controls, except: [:show]
  #
  get 'reports/index'

  resources :sorbate_samples
  resources :deviation_samples
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

  resources :drying_methods
  resources :product_types
  resources :humidity_samples

  resources :elements
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #get '/' => "elements#index"
  #get '/' => "pages#home_quality_controls"

  resources :caliber_samples

  namespace :calibrado do
    resources :caliber_samples
  end

  namespace :secado do
    resources :caliber_samples
  end

  root "pages#home"

end
