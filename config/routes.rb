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
  put    'account/:id',                         to: 'users#update',  as: 'update_account'
  get    'account/:id',                         to: 'users#edit',    as: 'edit_account'
  delete 'account/:id',                         to: 'users#destroy', as: 'destroy_account'
  put    'account/:id/resend_confirmation',     to: 'users#resend_confirmation', as: 'resend_confirmation'
  delete 'account/:id/delete',                  to: 'users#delete_user',         as: 'delete_user'
  put    'accounts',                            to: 'users#bulk_update',         as: 'user_bulk_update'

  # Unlock a user's account
  post   'account/:id/unlock', to: 'users#unlock',        as: :user_unlock

  # Block / unblock a user's account
  post   'account/:id/block',  to: 'users#block',         as: :user_block

  # Resend the invite to join an organization to a user
  post   'account/:id/invite', to: 'users#resend_invite', as: :resend_invite

  # Resource invites
  # Used to invite users to join a specific poll, survey, event, etc.
  resources :resource_invites

  # Invite routes
  # Invite routes are only used to invite a user to join an existing Organization
  resources :invites, only: %i[ edit create new update ]

  # User routes
  resources :users, only: %i[create new] do
    collection do
      get 'search',        action: :search_users
      get 'invite_search', action: :search_users_and_groups_for_invites
    end
  end
  resources :profiles,  only: %i[ update edit ]

  # Food for Thought routes
  resources :food_for_thought, only: %i[show]

  # Session routes
  post   'login',  to: 'sessions#create'
  get    'login',  to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'


  # Google OAuth routes
  # get '/auth/:provider/callback', to: 'sessions#omniauth'
  get '/auth/google_oauth2/callback', to: 'sessions#omniauth'

  # Password routes
  resources :passwords, only: %i[create edit new update], param: :password_reset_token
  post      'passwords/:id/reset', to: 'users#reset_password', as: :password_reset

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

  # Import CSV files
  resources :imports, only: %i[new create index show]

  # Event routes
  resources :events
  get 'event/:pin',       to: 'events#event',  as: :join_event
  get 'event/:id/stats',  to: 'events#stats',  as: :event_stats
  get 'event/:id/export', to: 'events#export', as: :event_export

  # Question routes
  resources :rooms do
    resources :questions, shallow: true
  end

  # Question votes
  post 'question/:votable_id/votes', to: 'votes#show', as: :question_votes,  votable_type: 'Question'

  # Polls
  # resources :polls
  get 'polls/user-stats', to: 'polls#user_stats'
  resources :polls do
    resources :poll_participations, only: [:create]
    resources :poll_options, only: [:create]
  end

  # Polls votes (aka the PollOption as Polls are not votable)
  # votable_id is the id of the PollOption the user is voting for (up_vote, down_vote or cancel)
  post 'poll/:votable_id/votes', to: 'votes#show', as: :poll_votes,  votable_type: 'PollOption'

  # Settings routes
  resources :settings, only: [:index]

  # Notification routes
  resources :notifications, only: [:index]
  put 'notifications/:id', to: 'notifications#mark_as_read',     as: :mark_as_read
  put 'notifications',     to: 'notifications#mark_all_as_read', as: :mark_as_read_all

  # Display the user's questions
  resources :your_questions, only: [:index, :show]

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
  # and sub-routes
  resources :organization, only: [:show, :update, :edit], direct_upload: true do
    resources :users, only: [:index]
    resource  :ssos,  only: [:update, :edit], shallow: true
    member do
      post   :upload_logo
    end
  end

  # Strip routes
  # Manage subscriptions
  resources :subscriptions
  get 'checkout/success', to: 'checkout#success', as: :checkout_success
  
  # Webhooks
  namespace :webhooks do
    # Stripe
    resources :stripe, only: :create
  end

  # Error pages
  match '/404', to: 'errors#not_found', via: :all
  match '/422', to: 'errors#unacceptable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  # Defines the main root path route ("/")
  # Must be the last route in the file
  root 'welcome#index'
end
