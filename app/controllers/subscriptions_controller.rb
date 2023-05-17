class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, only: %i[edit destroy update show]
  before_action :redirect_if_unauthenticated, except: %i[index new create]
  
  include StripeBillingPortalConfig

  # GET /subscriptions
  def index
    @plans = Plan.where(active: true)
  end

  # POST /subscriptions
  def create

    price = Plan.first.price_y
    plan = Plan.first

    session = Stripe::Checkout::Session.create(
      # client_reference_id: current_user.organization.id,
      success_url: root_url + "success?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: subscriptions_url,
      payment_method_types: ['card'],
      mode: 'subscription',
      # customer_email: current_user.email,
      line_items: [{
        quantity: 1,
        price: calculate_order_amount(ordered_seats, price, plan),
      }]
    )

    redirect_to session.url, allow_other_host: true, status: :see_other
  end

  def new

  end

  def edit

  end

  def update

  end

  private

  def calculate_order_amount(ordered_seats, price)
    if ordered_seat > plan.max_seats || ordered_seat < plan.min_seat
      raise ArgumentError, "Invalid number of ordered seats."
    end

    ordered_seats * price
  end

end
