# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
max_threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
min_threads_count = ENV.fetch('RAILS_MIN_THREADS') { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies that the worker count should equal the number of processors in production.
if ENV["RAILS_ENV"] == "production"
  require "concurrent-ruby"
  worker_count = Integer(ENV.fetch("WEB_CONCURRENCY") { Concurrent.physical_processor_count })
  workers worker_count if worker_count > 1
end

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
#
worker_timeout 3600 if ENV.fetch('RAILS_ENV', 'development') == 'development'

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
# port ENV.fetch('PORT') { 3000 }

# Specifies the `environment` that Puma will run in.
#
rails_env = ENV.fetch('RAILS_ENV') { 'development' }
environment rails_env

# Allow puma to be restarted by `bin/rails restart` command.
# plugin :tmp_restart

if %w[production staging].member?(rails_env)
  # Set the directory
  app_dir = File.expand_path("../../..", __FILE__)
  shared_dir = "#{app_dir}/shared"

  # Logging
  # stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true
  stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

  # Set master PID and state locations
  pidfile "#{shared_dir}/tmp/pids/puma.pid"
  state_path "#{shared_dir}/tmp/pids/puma.state"

  # Change to match your CPU core count
  workers ENV.fetch("WEB_CONCURRENCY") { 2 }

  preload_app!

  # Set up socket location
  # bind "unix://#{shared_dir}/tmp/sockets/thepew-puma.sock"
  bind "unix:///tmp/thepew-puma.sock"

  before_fork do
    # app does not use database, uncomment when needed
    # ActiveRecord::Base.connection_pool.disconnect!
  end

  on_worker_boot do
    ActiveSupport.on_load(:active_record) do
      # app does not use database, uncomment when needed
      db_url = ENV.fetch('DATABASE_URL')
      puts "puma: connecting to DB at #{db_url}"
      ActiveRecord::Base.establish_connection(db_url)
    end
  end
elsif rails_env == "development"
  # Specifies the `port` that Puma will listen on to receive requests; default is 3000.
  port   ENV.fetch("PORT") { 3000 }

  # Specifies the `pidfile` that Puma will use.
  pidfile ENV.fetch('PIDFILE') { 'tmp/pids/server.pid' }

  plugin :tmp_restart
end