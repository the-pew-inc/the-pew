# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Load the SCM plugin appropriate to your project:
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
require "capistrano/rails"
require "capistrano/rbenv"
require "capistrano/bundler"
require "capistrano/rails/assets"

# To trigger a db migration use:
# RUN_MIGRATIONS=true bundle exec cap production deploy:migrate
if ENV['RUN_MIGRATIONS']
  require 'capistrano/rails/migrations'
end

require "whenever/capistrano"

# require "capistrano/sidekiq"
# install_plugin Capistrano::Sidekiq
# install_plugin Capistrano::Sidekiq::Systemd

require 'capistrano/puma'
install_plugin Capistrano::Puma  # Default puma tasks
# install_plugin Capistrano::Puma::Systemd

set :rbenv_type, :user
set :rbenv_ruby, "3.3.0"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
