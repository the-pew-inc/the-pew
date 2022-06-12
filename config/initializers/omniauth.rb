Rails.application.config.middleware.use(OmniAuth::Builder) do
  if Rails.env.production?
    provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
  else
    provider :google_oauth2, Rails.application.credentials.google[:client_id], Rails.application.credentials.google[:client_secret]
  end
end
