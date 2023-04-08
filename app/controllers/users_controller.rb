class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[edit destroy update index]
  before_action :redirect_if_authenticated, only: %i[create new]

  # Add invisible_captcha
  invisible_captcha only: [:create, :update]

  # GET /organization/:id/users
  def index
    @organization = Organization.find(params[:organization_id])
    @users = @organization.users.includes([:profile])
  end

  def create
    @user = User.new(create_user_params)

    # Cannot register with an email that receieved an invitation to join an organization
    user_was_invited? and return 

    if @user.save
      after_login_path = session[:user_return_to] || root_path
      login(@user)
      redirect_to(after_login_path, notice: 'You are successfully signed in. Please check your email for confirmation instructions.')
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def destroy
    @user = User.find(params[:id])
    
    # make sure the user is not the current user
    not_owner and return

    # disconnect the user from the current session
    reset_session

    # delete the user
    @user.destroy

    redirect_to(root_path, notice: 'Your account has been deleted.')
  end

  def edit
    @user = User.find(params[:id])

    # make sure the user is not the current user
    not_owner and return

    # retrieve the user's sessions
    @active_sessions = @user.active_sessions.order(created_at: :desc)
  end

  def new
    @user = User.new
    @user.build_profile
    session[:user_return_to] = URI(request.referer || '').path
  end

  def update
    @user = User.find(params[:id])

    # make sure the user is not the current user
    not_owner and return

    # default success message
    msg = 'Account updated successfully.' 

    # If the user's account is locked, do nothing but warn them
    is_locked and return 
      
    # If the user is changing their password, check that the current password is correct & that the user provides a new password
    update_password and return

    msg = user_updates_their_email(msg)

    # Save the user's changes
    if @user.update(update_user_params)
      redirect_to(root_path, notice: msg)
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def reset_password
    # TODO make sure the user is an admin or the owner of the organization
    @user = User.find(params[:id])
    if @user
      # Disconnect the user
      @user.active_sessions.destroy_all

      # Invalidate the previous password
      @user.update_columns(password_digest: nil)

      # Send password reset email
      @user.send_password_reset_email!
      flash.now[:success] = "We just sent reset instructions to ${@user.email}."
      redirect_to(organization_users_path(@user.organization.id))
    else
      redirect_to(organization_users_path(@user.organization.id), alert: 'Something went wrong. If this error persist, please contact your administrator.')
    end
  end

  # Used to resent the confirmation email to a user when a user can login, but is not confirmed yet
  # This action is done by the user only from the profile section of the app
  def resend_confirmation
    @user = User.find(params[:id])
    
    # Make sure the user is entitled to resend the confirmation email
    not_owner and return

    if @user.confirmed
      # Make sure the user is not already confirmed
      redirect_to(root_path, notice: 'Your account is already confirmed.')
    else
      # Otherwise, send the confirmation email
      @user.send_confirmation_email!
      redirect_to(edit_account_path, notice: 'Please check your email for confirmation instructions.')
    end
  end

  private

  def create_user_params
    params.require(:user).permit(:email, :password, profile_attributes: [:nickname])
  end

  def update_user_params
    params.require(:user).permit(:email, :current_password, :password, profile_attributes: [:nickname])
  end

  # Method to check if the user is changing their password
  # - make sure the old and new password exists
  # - make sure that the old password is valid
  # - make sure that the new and old passwords are not the same
  def update_password
    current_password = update_user_params[:password] if update_user_params[:password].present?
    new_password = update_user_params[:current_password].present? ? update_user_params[:current_password] : nil
    if current_password && new_password
      # Make sure the current and new passwords are not the same
      if current_password == new_password
        flash.now[:alert] = 'New and current passwords must be different.'
        render(:edit, status: :unprocessable_entity) and return true
      end

      # Make sure the current password is correct
      if !@user.authenticate(update_user_params[:current_password])
        flash.now[:alert] = 'The information you provided to update your password is incorrect.'
        render(:edit, status: :unprocessable_entity) and return true
      end
    end

  end

  def user_updates_their_email(msg)
    # If the user is updating their email, send a confirmation email and adavise them to check their email
    if update_user_params[:email].present? && update_user_params[:email] != @user.email
      'Email & account updated successfully. Please check your mail for confirmation instructions.' 
    else
      msg
    end
  end

  # Make sure the user is not the current user
  def not_owner
    if @user.id != current_user.id
      flash.now[:alert] = 'You do not have permission to edit this user.'
      render(:edit, status: :unprocessable_entity) and return true
    end
  end


  def is_locked
    if @user.locked
      flash.now[:alert] = 'Your account has been locked. Please contact your admin.'
      render(:edit, status: :unprocessable_entity) and return true
    end
  end

  def user_was_invited?
    user = User.find_by(email: @user.email)

    if user.invited && user.accepted_invitation_on.nil?
      flash[:alert] = 'The email address you used has a pending invitation. Check your mailbox for an invite.'
      redirect_to(root_path) and return true
    end
  end

end
