Rails.application.routes.draw do
  resources :questions
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "welcome#index"

  # Account routes
  put "account", to: "users#update"
  get "account", to: "users#edit"
  delete "account", to: "users#destroy"

  # User routes
  post "sign_up", to: "users#create"
  get "sign_up", to: "users#new"

  # Session routes
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "login", to: "sessions#new"

  # Password routes
  resources :passwords, only: [:create, :edit, :new, :update], param: :password_reset_token

  # Confirmation routes
  resources :confirmations, only: [:create, :edit, :new], param: :confirmation_token

  # Active session routes
  resources :active_sessions, only: [:destroy] do
    collection do
      delete "destroy_all"
    end
  end
end
