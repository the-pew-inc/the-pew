source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# IMPORTANT: This must be the first gem listed
# Add support to appmap in development and test
gem 'appmap', '0.100.0', :groups => [:development, :test]


# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.5'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.4'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 6.3.0'

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem 'jsbundling-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem 'cssbundling-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Faster JSON processing [https://github.com/ohler55/oj/blob/develop/pages/Rails.md]
gem 'oj', '~> 3.15.0'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 5.0.5'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem 'kredis'

# Sidekiq [https://github.com/mperham/sidekiq]
gem 'sidekiq', '~>7.1.0'

# Add Noticed to support notifications [https://github.com/excid3/noticed]
gem 'noticed', '~> 1.5'

# Adding support to View Component (better than partials ;-) ) [https://github.com/github/view_component]
gem 'view_component'

# User authentication
# Use Argon2 to hash passwords [https://github.com/technion/ruby-argon2]
gem 'argon2', '~> 2.2.0'

# Export to Excel
# [https://github.com/caxlsx/caxlsx_rails]
# [https://dev.to/yarotheslav/export-from-database-table-to-excel-workbook-level-1-55jd]
gem 'caxlsx'
gem 'caxlsx_rails'

# Parse Excel xlsx files
# [https://github.com/martijn/xsv]
gem 'xsv'

# Adding OAuth2 support [https://github.com/omniauth/omniauth]
gem 'omniauth', '~> 2.1.0'
# Adding Google Sign-in support
gem 'omniauth-google-oauth2' , '~> 1.1.1'
# Required when not using Devise
gem 'omniauth-rails_csrf_protection' 

# Adding invisible_captcha [https://github.com/markets/invisible_captcha]
gem 'invisible_captcha', '~> 2.1.0'

# Adding Pundit to manage authorizations [https://github.com/varvet/pundit]
gem 'pundit'
# Adding Rolify to manage roles [https://github.com/RolifyCommunity/rolify]
gem 'rolify', '~> 6.0.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Add Merit [https://github.com/merit-gem/merit]
# Used for badges, reputation, etc.
gem 'merit'

# Mailer - Sendgrid [https://github.com/sendgrid/sendgrid-ruby]
gem 'sendgrid-actionmailer', '~> 3.2.0'

# Monitoring - Honeybadger []
gem 'honeybadger', '~> 5.0'

# Use Sass to process CSS
# gem "sassc-rails"

# Nokogiri to parse HTML and more [https://github.com/sparklemotion/nokogiri]
gem 'nokogiri', '~> 1.15.0'

# Download
gem 'down', '~> 5.0'

# Tracking changes using PaperTrail [https://github.com/paper-trail-gem/paper_trail]
gem 'paper_trail'

# Active storage validations [https://github.com/igorkasyanchuk/active_storage_validations]
gem 'active_storage_validations', '~> 1.0.0'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'
gem 'ruby-vips', '>= 2.1.0'
gem 'aws-sdk-s3', require: false

# Octokig [https://github.com/octokit/octokit.rb]
# Mostly used to import openAI prompts from GitHub repo using the import_prompts.rake task
gem 'octokit', '~> 6.1.1'

# Pagination [https://github.com/ddnexus/pagy]
gem 'pagy', '~> 6.0.0'

# Countries [https://github.com/countries/countries]
gem 'countries', '~> 5.5.0', require: 'countries/global'

# Validate URL format [https://github.com/perfectline/validates_url]
gem 'validate_url'

# Tracking
# Ahoy [https://github.com/ankane/ahoy]
gem 'ahoy_matey'

# Group date [https://github.com/ankane/groupdate]
gem 'groupdate'

# Chart [https://chartkick.com]
gem 'chartkick'

# openAI [https://github.com/alexrudall/ruby-openai]
gem 'ruby-openai', '~> 4.2.0'

# Adding pgsearch
gem 'pg_search', '~> 2.3.6'

# Stripe (payment, subscription processing) [https://github.com/stripe/stripe-ruby]
gem 'stripe', '~> 8.5.0'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  # Faker, gem for generating fake data for testing [https://github.com/faker-ruby/faker]
  gem 'faker', :git => 'https://github.com/faker-ruby/faker.git'
  
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Add support to Rubocop [https://github.com/rubocop/rubocop]
  gem 'rubocop', '~> 1.50', require: false
  gem 'rubocop-rails', require: false

  # Add support to Brakeman [https://github.com/presidentbeef/brakeman]
  # Vulnerability scanner
  gem 'brakeman'

  # Add Model annotations
  gem 'annotate', '~>3.2.0'

  # Add Bullet to monitor and help fix N+1 DB queries
  gem 'bullet'

  # # # # # # # # # # # # # # # # # # # # # #
  # The following gems are added to         #
  # facilitate the deployment to Digital    #
  # Ocean.
  # [https://gorails.com/deploy/ubuntu/22.04]
  gem 'capistrano', '~> 3.17',            require: false
  gem 'capistrano-rails', '~> 1.6.3',     require: false
  gem 'capistrano-rbenv', '~> 2.2.0',     require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma', '~> 6.0.0.beta1',   require: false
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'

  # Adding SimpleCov [https://github.com/simplecov-ruby/simplecov]
  # SimpleCov is a test coverage for Rails. Used by CodeClimate
  # Read [https://docs.codeclimate.com/docs/configuring-test-coverage] for more information
  # on how to integrate ith CodeClimate
  gem 'simplecov', require: false
end
