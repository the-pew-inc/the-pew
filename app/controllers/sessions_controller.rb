class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: %i[create new]
  before_action :authenticate_user!, only: [:destroy]
  before_action :setup_apple_client, only: [:apple_callback]

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

  def new; end

  def omniauth
    user = from_omniauth(request.env['omniauth.auth'])
    if user.valid?
      session[:user_id] = user.id
      after_login_path = session[:user_return_to] || root_path
      login(user)
      redirect_to(after_login_path, notice: 'Signed in.')
    else
      redirect_to(login_path, alert: 'There was an error while trying to authenticate you using Google.')
    end
  end

  # Apple Sign In
  def apple_callback
    # return unprocessable_entity unless params[:code].present? && params[:identity_token].present?
    if !params[:code].present? || !params[:identity_token].present?
      logger.error "Error: Apple Sign in failed. Missing code or identity_token"
      flash.now[:alert] = 'Error: authentication param missing.'
      render(:new, status: :unprocessable_entity)
      return
    end
    
    @client.authorization_code = params[:code]
    
    begin
      token_response = @client.access_token!
    rescue AppleID::Client::Error => e
      logger.error "Error: #{e.message}"
      flash.now[:alert] = "Error: #{e.message}"
      render(:new, status: :unprocessable_entity)
      return
    end
    
    id_token_back_channel = token_response.id_token
    id_token_back_channel.verify!(
      client: @client,
      access_token: token_response.access_token)

    id_token_front_channel = AppleID::IdToken.decode(params[:identity_token])
    id_token_front_channel.verify!(
      client: @client,
      code: params[:code],
    )
    
    # Extract Apple ID_Token
    id_token = token_response.id_token
        
    email = id_token.email
    # Check if user exists with this email
    u = User.find_by(email: email)
    if u && u.provider.nil?
      # Return to the login page with an error
      redirect_to(login_path, alert: 'This email is already registered with an account.')
      return
    end

    # If the user does not exist with this email, then process
    user = User.find_by(apple_uid: id_token.sub, provider: response[:provider])
    
    if user.present?
      # The user exists, make sure the account is not locked
      user.profile.nickname = id_token.name
      if user.locked
        redirect_to(:new, alert: 'Your account is locked.')
        return
      end
    else
      # The user does not exist, so create a new user
      user = User.new(
        apple_uid: uid,
        email: email,
        provider: :apple,
        uid: email,
        confirmed: true,
        confirmed_at: Time.current.utc,
      )
      user.build_profile
      user.profile.nickname = id_token.name
      user.password = SecureRandom.alphanumeric(16)
      user.save!
    end
    
    # Create a new session for the user
    session[:user_id] = user.id
    after_login_path = session[:user_return_to] || root_path
    login(user)
    redirect_to(after_login_path, notice: 'Signed in.')
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
      user.profile.nickname = response[:info][:name]
    else
      # The user does not exist, so create a new user
      user = User.new(email: email, uid: response[:uid], provider: response[:provider])
      user.build_profile
      user.profile.nickname = response[:info][:name]
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

  # Apple sign in private methods
  def setup_apple_client
    if Rails.env.production?
      @client ||= AppleID::Client.new(
        identifier: ENV['APPLE_CLIENT_ID'],
        team_id: ENV['APPLE_TEAM_ID'],
        key_id: ENV['APPLE_KEY'],
        private_key: OpenSSL::PKey::EC.new(ENV['APPLE_PRIVATE_KEY']),
        redirect_uri: ENV['APPLE_REDIRECT_URI']
        )
    else
      @client ||= AppleID::Client.new(
        identifier: Rails.application.credentials.apple[:apple_client_id],
        team_id: Rails.application.credentials.apple[:apple_team_id],
        key_id: Rails.application.credentials.apple[:apple_key],
        private_key: OpenSSL::PKey::EC.new(Rails.application.credentials.apple[:apple_private_key]),
        redirect_uri: Rails.application.credentials.apple[:apple_redirect_uri]
      )
    end
  end
end