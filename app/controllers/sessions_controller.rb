class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]
  before_action :authenticate_user!, only: [:destroy]

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user
      if !@user.confirmed
        redirect_to new_confirmation_path, alert: "You must confirm your email before being able to login."
      elsif @user.locked
        redirect_to :new, alert: "Your account is locked."
      else
        if @user.authenticate(params[:user][:password])
          after_login_path = session[:user_return_to] || root_path
          active_session = login @user
          remember(active_session) if params[:user][:remember_me] == "1"
          redirect_to after_login_path, notice: "Signed in."
        else 
          flash.now[:alert] = "Incorrect email or password."
          render :new, status: :unprocessable_entity
        end
      end
    else
      flash.now[:alert] = "Incorrect email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    forget_active_session
    logout
    redirect_to root_path, notice: "Signed out."
  end

  def new
  end

  def omniauth
    user = from_omniauth(request.env["omniauth.auth"])
    if user.valid?
      session[:user_id] = user.id
      after_login_path = session[:user_return_to] || root_path
      login user
      redirect_to after_login_path, notice: "Signed in."
    else
      redirect_to login_path, alert: "There was an error while trying to authenticate you using Google."
    end
  end

  private

  def from_omniauth(response)
    pp response
    
    email = response[:info][:email]
    # Check if user exists with this email
    u = User.find_by(email: email)
    if u && u.provider == nil
      # Return to the login page with an error
      redirect_to login_path, alert: "This email is already registered with an account."
      return
    end

    # If the user does not exist with this email, then process
    user = User.find_or_initialize_by(uid: response[:uid], provider: response[:provider])
    user.email = email
    user.profile.nickname = response[:info][:name]
    user.password_digest = SecureRandom.hex(16)
    # user.image_url = response["info"]["image"]
    # user.oauth_token = response["credentials"]["token"]
    # user.oauth_expires_at = response["credentials"]["expires_at"]
    user.save

    # As the user is signing in with Google, we do not need to confirm the email
    user.confirm!

    # Return the user
    user
  end
end
