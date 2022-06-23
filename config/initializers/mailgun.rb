Mailgun.configure do |config|
  config.api_key = ENV['MAILGUN_API_KEY'] if Rails.env.production
end