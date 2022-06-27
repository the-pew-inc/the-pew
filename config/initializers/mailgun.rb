if Rails.env.production?
  Mailgun.configure do |config|
    config.api_key = ENV['MAILGUN_API_KEY']
  end
end