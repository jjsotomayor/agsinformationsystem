Rails.application.routes.draw do
  get 'pages/home'

  get 'pages/home_quality_controls'

  get 'users/index'

  devise_for :users
  resources :users, only: [:index]
  resources :drying_methods
  resources :product_types
  resources :humidity_samples
  resources :elements
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #get '/' => "elements#index"
  get '/' => "pages#home_quality_controls"
end
