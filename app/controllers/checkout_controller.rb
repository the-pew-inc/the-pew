class CheckoutController < ApplicationController

  # GET /checkout/success?session_id={STRIPE_GENERATED_SESSION_ID}
  def success
    if params[:session_id]

      begin
        session = Stripe::Checkout::Session.retrieve(params[:session_id])
        @customer = Stripe::Customer.retrieve(session.customer)        
      rescue Stripe::InvalidRequestError
        redirect_on_error
      end
    else
      redirect_on_error
    end
  end

  private

  def redirect_on_error
    flash[:alert] = "Invalid or missing payment id"
    redirect_to subscriptions_path
  end

end
