class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: %i[create new]
  before_action :authenticate_user!, only: [:destroy]

  def create
    @user = User.find_by(email: params[:user][:email].downcase)

    user_was_invited? and return

    # If the user exists but uses an OTP, then redirect to the login page with an error
    if @user && (@user.provider? && @user.uid?)
      flash.now[:alert] = 'Incorrect authentication method.'
      render(:new, status: :unprocessable_entity)
      return
    end

    if @user
      if is_the_account_locked?
        redirect_to(login_path, alert: 'Your account is locked.')
        return
      elsif @user.authenticate(params[:user][:password])
        after_login_path = session[:user_return_to] || root_path
        active_session = login(@user)
        remember(active_session) if params[:user][:remember_me] == '1'

        # Reset failed_attempts if needed
        reset_failed_attempts
        
        # If everything is ok, redirect the user to where they were suppose to go.
        redirect_to(after_login_path, notice: 'Signed in.')
        return
      else
        flash.now[:alert] = 'Incorrect email or password.'
        should_we_lock_the_account?
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
        redirect_to edit_profile_path(user), notice: "Let the others know your name"
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


  # Check if the user has still a pending invite
  # If this is the case we deny access to the app and require the user to go back to the
  # invite flow.
  def user_was_invited?
    if @user && @user.invited && @user.accepted_invitation_on.nil?
      flash[:alert] = 'The email address you are using has a pending invite. Please check your mailbox for an invite.'
      redirect_to(root_path) and return true
    end
  end

  # Method used to increment the failed_attempts column in the User model
  # and to compare the resulting value to the max_failed_attempts defined for the user's organization
  # Default max_failed_attempts is 5
  # So as we start from 0 when we reach 5 then user's locked column will be set to true
  # Locked accounts can be unlocked by an admin or after waiting a certain time (default 900 seconds)
  def should_we_lock_the_account?
    @user.increment!(:failed_attempts, 1)
    if @user.failed_attempts >= @user.organization.max_failed_attempts
      @user.lock!
    end
  end

  # Return true when 1. the locked value is true or 2. when the account is locked and the timeout
  # to automatically reset the locked value has not been reached.
  # Return false when the locked value is false
  def is_the_account_locked?
    if @user.locked && (@user.locked_at + @user.organization.failed_attempts_timeout <= Time.current)
      @user.unlock!
      return true
    end
      return @user.locked
  end

  # Used to reset the failed_attempts counter to 0 when a successful login is recorded
  # before reaching the value that locks the user's account
  def reset_failed_attempts
    if @user.failed_attempts != 0 && !@user.locked
      @user.update_columns(failed_attempts: 0)
    end
  end

end