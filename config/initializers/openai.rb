OpenAI.configure do |config|
  if Rails.env.production?
    config.access_token = ENV["OPENAI_ACCESS_TOKEN"]
    config.organization_id = ENV["OPENAI_ORGANIZATION_ID"] # Optional.
  else
    config.access_token = Rails.application.credentials.openai[:access_token] 
    config.organization_id = Rails.application.credentials.openai[:organization_id]
  end
end
