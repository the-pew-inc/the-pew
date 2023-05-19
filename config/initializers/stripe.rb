# Configure how Stripe Keys are retrieved by the application
# Test and Dev values are extracted from the development and test.yml files
if Rails.env.production?
  Rails.configuration.stripe = {
    publishable_key: ENV["STRIPE_PUBLISHABLE_KEY"],
    secret_key:      ENV["STRIPE_SECRET_KEY"],
  }
else
  Rails.configuration.stripe = {
    publishable_key: Rails.application.credentials.stripe[:publishable_key], 
    secret_key:      Rails.application.credentials.stripe[:secret_key],
  }
end


Stripe.api_key = Rails.configuration.stripe[:secret_key]
