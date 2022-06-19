Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Account routes
  put 'account/:id', to: 'users#update', as: 'update_account'
  get 'account/:id', to: 'users#edit', as: 'edit_account'
  delete 'account/:id', to: 'users#destroy', as: 'destroy_account'
  put 'account/:id/resend_confirmation', to: 'users#resend_confirmation', as: 'resend_confirmation'

  # User routes
  post 'sign_up', to: 'users#create'
  get 'sign_up', to: 'users#new'

  # Session routes
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'login', to: 'sessions#new'

  # Google OAuth routes
  get '/auth/:provider/callback', to: 'sessions#omniauth'

  # Apple Sign In routes
  post 'auth/apple' => 'sessions#apple_callback'

  # Password routes
  resources :passwords, only: %i[create edit new update], param: :password_reset_token

  # Confirmation routes
  resources :confirmations, only: %i[create edit new], param: :confirmation_token

  # Active session routes
  resources :active_sessions, only: [:destroy] do
    collection do
      delete 'destroy_all'
    end
  end

  # Event routes
  resources :events do
    # Manage questions routes
    get 'manage_questions/index'
  end

  # Question routes
  resources :questions

  # Answer routes / ONLY accessible via the https://ask. domain
  constraints subdomain: 'ask' do
    get '(/:pin)', to: "asks#index", as: :ask_root
    post '/pin', to: 'asks#validate_pin'
    get '/event/:event_id', to: 'asks#event_rooms', as: :event_rooms
  end

  # Defines the main root path route ("/")
  # Must be the last route in the file
  root 'welcome#index'
end
