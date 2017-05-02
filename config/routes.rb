Rails.application.routes.draw do
  resources :sorbate_samples
  resources :deviation_samples
  get 'pages/home'

  get 'pages/home_quality_controls'

  get 'users/index'

  devise_for :users
  resources :users, only: [:show, :index]
  resources :drying_methods
  resources :product_types
  resources :humidity_samples

  resources :elements
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #get '/' => "elements#index"
  root "pages#home_quality_controls"
  #get '/' => "pages#home_quality_controls"

  resources :caliber_samples

  namespace :calibrado do
    resources :caliber_samples
  end

  namespace :secado do
    resources :caliber_samples
  end


end
