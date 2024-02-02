class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  before_action :redirect_if_unauthenticated, except: %i[index new create]
  before_action :load_plan, only: %i[new create]

  # include StripeBillingPortalConfig

  # GET /subscriptions
  def index
    @plans = Plan.where(active: true)
    @starter    = @plans.find_by(label: 'Starter')
    @pro        = @plans.find_by(label: 'Pro')
    @enterprise = @plans.find_by(label: 'Enterprise')
  end

  def new
    # plan_id is required
    unless params[:plan_id]
      flash[:alert] = 'Missing plan'
      redirect_to(subscriptions_path, status: :unprocessable_entity)
      return
    end

    @plan = Plan.find(params[:plan_id])
  # Report incorrect plan_id or missing plan
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Missing or incorrect plan'
    redirect_to(subscriptions_path, status: :not_found)
  end

  def edit; end

  # POST /subscriptions
  def create
    # Making we sure to receive expected parameters
    if !params[:plan_id] || !params[:seats] || !params[:interval] || !params[:email]
      render_error('Missing parameter')
      return
    end

    # Set variables
    ordered_seats = params[:seats]
    interval      = params[:interval]
    email         = params[:email]

    organization_website = params[:website] || nil

    organization_name = if params[:organiztaion] && params[:organiztaion].present?
                          params[:organization]
                        else
                          '__default__'
                        end

    # Validate the email format and uniqueness
    begin
      validate_email(email)
      # Continue with the execution flow if the email is valid
    rescue StandardError => e
      render_error(e.message)
      return
    end

    # Validates number of seats
    if ordered_seats.is_a?(Integer) && ordered_seats <= @plan.max_seats && ordered_seats >= @plan.min_seats
      flash[:alert] = 'Incorrect number of seats'
      render(:new, status: :unprocessable_entity)
      return
    end

    # Creating the user OR getting the current one
    user = if user_signed_in?
             current_user
           else
             User.new
           end
    user.email = email
    user.invited_at = Time.current
    user.invited = true
    unless user.save
      render_error('An error occured while creating your user account')
      return
    end

    # Create the organization for the user
    organization = Organization.new
    organization.name    = organization_name
    organization.website = organization_website

    unless organization.save
      user.destroy
      render_error('An error occured while creating your organization')
      return
    end

    # Connect the user to their organization
    member = Member.new
    member.organization_id = organization.id
    member.user_id         = user.id
    member.owner           = true
    unless member.save
      user.destroy
      organization.destroy
      render_error('An error occured')
      return
    end

    # Creating Stripe session
    begin
      session = Stripe::Checkout::Session.create(
        allow_promotion_codes: true,
        client_reference_id: user_signed_in? ? current_user.organization.id : organization.id,
        customer_email: user_signed_in? ? current_user.email : email,
        cancel_url: subscriptions_url,
        currency: 'USD',
        expires_at: 3.hours.from_now.to_i,
        line_items: [
          {
            quantity: ordered_seats,
            price: (interval == 1 ? @plan.stripe_price_mo : @plan.stripe_price_y)
          }
        ],
        mode: 'subscription',
        payment_method_types: %w[card paypal us_bank_account],
        success_url: root_url + 'checkout/success?session_id={CHECKOUT_SESSION_ID}'
      )
    rescue Stripe::StripeError => e
      member.destroy
      organization.destroy
      user.destroy
      render_error('An error occured while connecting to Stripe. Please try again in a few minutes and if this error persists contact our support team.')
      return
    end
    # Process to Stripe checkout page
    redirect_to(session.url, allow_other_host: true, status: :see_other)
  end

  def update; end

  private

  def validate_email(email)
    return unless email.present?

    # Check email format
    raise(StandardError, 'Invalid email format') unless email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

    # Check email uniqueness in User model
    return unless User.exists?(email:)

    raise(StandardError, 'Email already exists')
  end

  def render_error(message)
    flash[:alert] = message
    render(:new, status: :unprocessable_entity)
  end

  def load_plan
    unless params[:plan_id]
      render_error('Missing plan')
      return
    end

    @plan = Plan.find_by(id: params[:plan_id])

    return if @plan

    render_error('Missing or incorrect plan')
  end
end
