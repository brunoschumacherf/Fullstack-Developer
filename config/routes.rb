Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  constraints(host: "127.0.0.1") do
    get "(*path)", to: redirect { |params, req| "#{req.protocol}localhost:#{req.port}/#{params[:path]}" }
  end

  root to: redirect("/login")

  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  get "register", to: "registrations#new", as: :register
  post "register", to: "registrations#create"

  resource :profile, only: %i[show update destroy]

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :users
    resources :user_imports, only: %i[create show]
  end
end
