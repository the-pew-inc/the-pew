Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Adding the sidekiq UI
  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_AUTH_USERNAME"])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_AUTH_PASSWORD"]))
  end if Rails.env.production?
  
  mount Sidekiq::Web => '/sidekiq'

  # Cookie acceptance
  get 'cookies', to: 'cookies#index'

  # User Account routes
  put 'account/:id', to: 'users#update', as: 'update_account'
  get 'account/:id', to: 'users#edit', as: 'edit_account'
  delete 'account/:id', to: 'users#destroy', as: 'destroy_account'
  put 'account/:id/resend_confirmation', to: 'users#resend_confirmation', as: 'resend_confirmation'

  # User routes
  resources :users,     only: %i[create new ]
  resources :profiles,  only: %i[update edit]

  # Session routes
  post 'login', to: 'sessions#create'
  get  'login', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'


  # Google OAuth routes
  # get '/auth/:provider/callback', to: 'sessions#omniauth'
  get '/auth/google_oauth2/callback', to: 'sessions#omniauth'

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

  # Dashboard routes
  resource :dashboard, only: [:show]

  # Event routes
  resources :events
  get 'event/:pin',       to: 'events#event', as: :join_event
  get 'event/:id/stats',  to: 'events#stats', as: :event_stats
  get 'event/:id/export', to: 'events#export', as: :event_export

  # Question routes
  resources :rooms do
    resources :questions, shallow: true
  end

  # Question routes / votes
  post 'question/:votable_id/votes', to: 'votes#show', as: :question_votes,  votable_type: 'Question'

  # Settings routes
  resources :settings, only: [:index]

  # Notification routes
  resources :notifications, only: [:index]
  put 'notifications/:id', to: 'notifications#mark_as_read',     as: :mark_as_read
  put 'notifications',     to: 'notifications#mark_all_as_read', as: :mark_as_read_all

  # Display the user's questions
  resources :your_questions, only: [:index]

  # Validate event PIN
  post '/', to: 'events#validate_pin', as: :pin

  # Legal routes
  get 'legal',         to: 'legal#index'
  get 'legal/ccpa',    to: 'legal#ccpa'
  get 'legal/coc',     to: 'legal#coc'
  get 'legal/privacy', to: 'legal#privacy'
  get 'legal/prp',     to: 'legal#prp'
  get 'legal/sp',      to: 'legal#sp'
  get 'legal/tos',     to: 'legal#tos'
  get 'legal/tou',     to: 'legal#tou'
  get 'legal/cp',      to: 'legal#cp'

  # Organization (aka Account model) routes
  get 'organization/:id',      to: 'account#show'
  get 'organization/:id/edit', to: 'account#edit'
  put 'organization/:id',      to: 'account#update'


  # Defines the main root path route ("/")
  # Must be the last route in the file
  root 'welcome#index'
end
