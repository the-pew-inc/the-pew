# config valid for current version and patch releases of Capistrano
lock "~> 3.18.0"

set :application, "thepew"
set :repo_url, "git@github.com:the-pew-inc/the-pew.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Not using ask to avoid being asked everytime we deploy
# changing the branch... as master no longer exists on GitHub
set :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :rails_env,    "production"
set :linked_dirs,  fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/#{fetch :application}"

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :keep_releases, 2

set :use_sudo, true

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# Puma
# Commented out as we control puma manually for the moment.
# set :puma_service_unit_name, "puma.service"
# set :puma_user, fetch(:user)
# set :puma_role, :web

# Sidekiq
# set :sidekiq_service_unit_name, "sidekiq"
# set :sidekiq_service_unit_user, :system
# set :sidekiq_env => fetch(:rack_env, fetch(:rails_env, fetch(:stage)))
# set :sidekiq_config, "config/sidekiq.yml"