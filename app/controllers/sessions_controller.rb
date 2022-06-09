class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]
  before_action :authenticate_user!, only: [:destroy]

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user.provider? && @user.uid?
      # User used an OTP account to login (Google, Apple Sign in, etc.).
      # Forcing user to login with the OTP account.
      flash.now[:alert] = "Incorrect authentication method."
      render :new, status: :unprocessable_entity
      return
    end

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
    require "down"

    email = response[:info][:email]
    # Check if user exists with this email
    u = User.find_by(email: email)
    if u && u.provider == nil
      # Return to the login page with an error
      redirect_to login_path, alert: "This email is already registered with an account."
      return
    end

    # If the user does not exist with this email, then process
    user = User.find_by(uid: response[:uid], provider: response[:provider])
    if user
      # The user exists, so update the user's info
      user.profile.nickname = response[:info][:name]
    else
      # The user does not exist, so create a new user
      user = User.new(email: email, uid: response[:uid], provider: response[:provider])
      user.build_profile
      user.profile.nickname = response[:info][:name]
      user.password = SecureRandom.alphanumeric(16)
      if response[:info][:email_verified]
      user.confirmed = true
      user.confirmed_at = Time.current
      else
        user.send_confirmation_email!
      end
    end

    # If there is no avatar, then try to get one from the response
    if !user.profile.avatar.attached?
      get_image_from_google_oauth(user, response)
    end

    # Save the user
    user.save!

    # Return the user
    user
  end

  private

  def get_image_from_google_oauth(user, response)
    image_url = response[:info][:image]
    # remove the size parameter at the end of the image url
    pattern = / =s\d+ /

    last = image_url.rindex(pattern)
    if last
      image_url = image_url[0..last-1]
    end
      
    # Download the image from the url
    tempavatar = Down.download(image_url)

    # Generate a unique filename
    filename = Time.current.to_s + SecureRandom.hex(16)
    user.profile.avatar.attach(io: tempavatar, filename: filename, content_type: tempavatar.content_type)
  end

end
