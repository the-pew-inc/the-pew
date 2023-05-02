ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start

require 'appmap/minitest'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all
  fixtures %w[users profiles organizations members active_sessions events rooms 
    questions attendances messages notifications topics votes import_results roles 
    polls poll_options]

  # Add more helper methods to be used by all tests here...


  def login(user)
    post login_path, params: { user: { email: user.email, password: 'password123' } }
  end

  def switch_timezone
    Time.zone
  end

end
