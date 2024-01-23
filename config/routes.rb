Rails.application.routes.draw do
  get 'profile/show'
  get 'home/index'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :profile, only: [:show]

  # namespace is used to group api controllers
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :organizations, only: [:index]
    end
  end

  # Defines the root path route ("/")
  root "home#index"
end
