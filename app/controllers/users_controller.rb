class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[edit destroy update]
  before_action :redirect_if_authenticated, only: %i[create new]

  def create
    @user = User.new(create_user_params)
    if @user.save
      redirect_to(root_path, notice: 'Please check your email for confirmation instructions.')
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

    if @user.id != current_user.id
      flash.now[:alert] = 'You do not have permission to edit this user.'
      render(:edit, status: :unprocessable_entity)
      return
    end

    # default success message
    msg = 'Account updated successfully.' 

    # If the user's account is locked, do nothing but warn them
    if !@user.locked
      
      # If the user is changing their password, check that the current password is correct & that the user provides a new password
      update_password and return

      msg = user_updates_their_email(msg)

      # Save the user's changes
      if @user.update(update_user_params)
        redirect_to(root_path, notice: msg)
      else
        render(:edit, status: :unprocessable_entity)
      end
    else
      flash.now[:alert] = 'Your account has been locked. Please contact support.'
      render(:edit, status: :unprocessable_entity)
    end
  end

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
        p '#### NEW AND OLD PASSWORD ARE THE SAME! #####'
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

end
