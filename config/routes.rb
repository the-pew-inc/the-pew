Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Adding the sidekiq UI
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Cookie acceptance
  get 'cookies', to: 'cookies#index'

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
  post 'auth/apple', to: 'sessions#apple_callback'
  post 'webhooks/apple', to: 'webhooks#apple'

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
  resources :events
  get 'event/:pin', to: 'events#event', as: :join_event

  # Question routes
  resources :rooms do
    resources :questions
  end

  # Notification routes
  resources :notifications, only: [:index]

  get 'question/:votable_id/votes', to: 'votes#show', as: :question_votes,  votable_type: 'Question' 

  # Display the user's questions
  resources :your_questions, only: [:index, :show, :destroy]

  # Validate event PIN
  post '/', to: 'events#validate_pin', as: :pin

  # Defines the main root path route ("/")
  # Must be the last route in the file
  root 'welcome#index'
end
