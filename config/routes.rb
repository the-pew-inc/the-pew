Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

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

  # Event routes
  resources :events do
    # Manage questions routes
    get "manage_questions/index"
  end

  # Question routes
  resources :questions 

  # Answer routes / ONLY accessible via the https://ask. domain
  constraints subdomain: "ask" do
    # get "/", to: "asks#index"
    root to: "asks#index", as: :ask_root
    post "/pin", to: "asks#validate_pin"
  end

  # Defines the main root path route ("/")
  # Must be the last route in the file
  root "welcome#index"
end
