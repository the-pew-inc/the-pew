class Webhooks::StripeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # docs: https://stripe.com/docs/payments/checkout/fulfill-orders
    # receive POST from Stripe
    payload = request.body.read
    signature_header = request.env['HTTP_STRIPE_SIGNATURE']

    # Stripe webhook secret passed as environment variable
    endpoint_secret = Rails.env.production? ? ENV.fetch('STRIPE_WEBHOOK_SECRET_KEY', nil) : Rails.application.credentials.stripe[:webhook_secret_key]

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
      render(json: { message: e }, status: :bad_request)
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render(json: { message: e }, status: :bad_request)
      return
    end

    # Handle Stripe event
    case event.type
    when 'payment_intent.created'
      logger.warn('payment_intent.created not yet supported')
    when 'checkout.session.completed', 'payment_intent.succeeded'
      fullfill_order(event.data.object)
    when 'customer.subscription.deleted', 'customer.subscription.updated'
      update_subscription(event.data.object)
    when 'plan.created', 'plan.updated'
      update_plan(event.data.object)
    else
      logger.warn("Unhandled event type: #{event.type}")
    end
  end

  private

  def fullfill_order(checkout_session)
    # Find user and assign customer id from Stripe
    # user = User.find(checkout_session.client_reference_id)
    user = User.find_by(email: checkout_session.customer_details.email)
    organization = user.organization
    organization.update!(stripe_customer_id: checkout_session.customer)

    # Retrieve new subscription via Stripe API using susbscription id
    stripe_subscription = Stripe::Subscription.retrieve(checkout_session.subscription)

    # Create new subscription with Stripe subscription details and user data
    Subscription.create!(
      active: true,
      current_period_start: Time.at(stripe_subscription.current_period_start).to_datetime,
      current_period_end: Time.at(stripe_subscription.current_period_end).to_datetime,
      customer_id: stripe_subscription.customer,
      interval: stripe_subscription.plan.interval,
      organization:,
      status: stripe_subscription.status,
      stripe_plan: stripe_subscription.plan.id,
      subscription_id: stripe_subscription.id
    )

    # Send the invitation email to the user
    user.send_invite!
  end

  def update_subscription(subscription)
    stripe_subscription = Stripe::Subscription.retrieve(subscription.id)
    subscription = Subscription.find_by(subscription_id: stripe_subscription.id)
    subscription.update!(
      status: subscription.status,
      current_period_start: Time.at(stripe_subscription.current_period_start).to_datetime,
      current_period_end: Time.at(stripe_subscription.current_period_end).to_datetime,
      plan: stripe_subscription.plan.id,
      interval: stripe_subscription.plan.interval
    )
  end

  def update_plan(stripe_plan)
    plan = Plan.find_or_initialize_by(stripe_product_id: stripe_plan.product)
    plan.update(
      label: stripe_plan.nickname,
      price_mo: stripe_plan.amount / 100.0, # Assuming amount is in cents
      active: stripe_plan.active
      # Add other attributes as needed
    )
  end
end
