Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      root "home#index" 
      resources :records
      resources :artists
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
  post "login" => "signin#create", as: :login
  delete "logout" => "signin#destroy", as: :logout
  post "signup" => "signup#create", as: :sign_up
end
