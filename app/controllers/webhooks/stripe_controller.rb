class Webhooks::StripeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # docs: https://stripe.com/docs/payments/checkout/fulfill-orders
    # receive POST from Stripe
    payload = request.body.read
    signature_header = request.env["HTTP_STRIPE_SIGNATURE"]

    # Stripe webhook secret passed as environment variable
    endpoint_secret = Rails.env.production? ? ENV["STRIPE_WEBHOOK_SECRET_KEY"] : Rails.application.credentials.stripe[:webhook_secret_key]
    
    # Making sure we start from an empty event
    event = nil

    # Make sure that the request comes from Stripe
    # by comparing the webhook_secret received with the one we have in store
    begin
      event = Stripe::Webhook.construct_event(
        payload, signature_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      render json: {message: e}, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render json: {message: e}, status: 400
      return
    end

    logger.debug event.inspect
    # Handle the event
    case event.type
    when 'checkout.session.completed'
      fullfill_order(event.data.object)
    when 'customer.subscription.deleted', 'customer.subscription.updated'
      update_subscription(event.data.object)
    else
      logger.warn "Unhandled event type: #{event.type}"
    end

  end

  private
  
  def fullfill_order(checkout_session)
    # Find user and assign customer id from Stripe
    # user = User.find(checkout_session.client_reference_id)
    user = User.find_by(:email => checkout_session.customer_details.email)
    user.update!(stripe_customer_id: checkout_session.customer)

    # Retrieve new subscription via Stripe API using susbscription id
    stripe_subscription = Stripe::Subscription.retrieve(checkout_session.subscription)

    # Create new subscription with Stripe subscription details and user data
    Subscription.create!(
      customer_id: stripe_subscription.customer,
      current_period_start: Time.at(stripe_subscription.current_period_start).to_datetime,
      current_period_end: Time.at(stripe_subscription.current_period_end).to_datetime,
      plan: stripe_subscription.plan.id,
      interval: stripe_subscription.plan.interval,
      status: stripe_subscription.status,
      subscription_id: stripe_subscription.id,
      user: user,
    )
  end

  def update_subscription(subscription)
    stripe_subscription = Stripe::Subscription.retrieve(subscription.id)
    user_subscription = Subscription.find_by(subscription_id: stripe_subscription.id)
    user_subscription.update!(
      status: subscription.status,
      current_period_start: Time.at(stripe_subscription.current_period_start).to_datetime,
      current_period_end: Time.at(stripe_subscription.current_period_end).to_datetime,
      plan: stripe_subscription.plan.id,
      interval: stripe_subscription.plan.interval,
    )
  end
end
