class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: %i[create new]
  before_action :authenticate_user!, only: [:destroy]

  def create
    @user = User.find_by(email: params[:user][:email].downcase)

    # If the user exists but uses an OTP, then redirect to the login page with an error
    if @user && (@user.provider? && @user.uid?)
      flash.now[:alert] = 'Incorrect authentication method.'
      render(:new, status: :unprocessable_entity)
      return
    end

    if @user
      if @user.locked
        redirect_to(:new, alert: 'Your account is locked.')
        return
      elsif @user.authenticate(params[:user][:password])
        after_login_path = session[:user_return_to] || root_path
        active_session = login(@user)
        remember(active_session) if params[:user][:remember_me] == '1'
        redirect_to(after_login_path, notice: 'Signed in.')
        return
      else
        flash.now[:alert] = 'Incorrect email or password.'
        render(:new, status: :unprocessable_entity)
        return
      end
    else
      flash.now[:alert] = 'Incorrect email or password.'
      render(:new, status: :unprocessable_entity)
      return
    end
  end

  def destroy
    forget_active_session
    logout
    redirect_to(root_path, notice: 'Signed out.')
  end

  def new
    session[:user_return_to] = URI(request.referer || '').path
  end

  def omniauth
    user = from_omniauth(request.env['omniauth.auth'])
    if user.valid?
      session[:user_id] = user.id
      after_login_path = session[:user_return_to] || root_path
      login(user)
      if user.profile.nickname == nil
        redirect_to edit_profile_path(user), notice: "Let the other know your name"
      else
        redirect_to(after_login_path, notice: 'Signed in.')
      end
    else
      redirect_to(login_path, alert: 'There was an error while trying to authenticate you using Google.')
    end
  end

  private

  def from_omniauth(response)
    require('down')

    email = response[:info][:email]
    # Check if user exists with this email
    u = User.find_by(email: email)
    if u && u.provider.nil?
      # Return to the login page with an error
      redirect_to(login_path, alert: 'This email is already registered with an account.')
      return
    end

    # If the user does not exist with this email, then process
    user = User.find_by(uid: response[:uid], provider: response[:provider])
    if user
      # The user exists, so update the user's info
      user.profile.nickname = response[:info][:name] || nil
    else
      # The user does not exist, so create a new user
      user = User.new(email: email, uid: response[:uid], provider: response[:provider])
      user.build_profile
      user.profile.nickname = response[:info][:name] || nil
      user.password = SecureRandom.alphanumeric(16)
      if response[:info][:email_verified]
        user.confirmed = true
        user.confirmed_at = Time.current.utc
      else
        user.send_confirmation_email!
      end
    end

    # If there is no avatar, then try to get one from the response
    get_image_from_google_oauth(user, response) unless user.profile.avatar.attached?

    # Save the user
    user.save!

    # Return the user
    user
  end

  def get_image_from_google_oauth(user, response)
    image_url = response[:info][:image]
    # remove the size parameter at the end of the image url
    pattern = / =s\d+ /

    last = image_url.rindex(pattern)
    image_url = image_url[0..last - 1] if last

    # Download the image from the url
    tempavatar = Down.download(image_url)

    # Generate a unique filename
    filename = Time.current.utc.to_s + SecureRandom.hex(16)
    user.profile.avatar.attach(io: tempavatar, filename: filename, content_type: tempavatar.content_type)
  end

end