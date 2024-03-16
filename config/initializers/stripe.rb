# Configure how Stripe Keys are retrieved by the application
# Test and Dev values are extracted from the development and test.yml files

Rails.configuration.stripe = {
    publishable_key: ENV["STRIPE_PUBLISHABLE_KEY"],
    secret_key:      ENV["STRIPE_SECRET_KEY"],
  }

Stripe.api_key = Rails.configuration.stripe[:secret_key]
