# Used to reset a password for a user, when this user is not logged in.
# To change their passwords, users have to use their profile page and the users_controller.rb
# is in charge of updating their passwords.

class PasswordsController < ApplicationController
  before_action :redirect_if_authenticated

  # Adding invisible_captcha
  invisible_captcha only: [:create, :update]

  def create
    @user = User.find_by(email: params[:user][:email].strip.downcase)
    if @user.present?
      if @user.confirmed?
        @user.send_password_reset_email!
        redirect_to(login_path, notice: "If that user exists we've sent instructions to their email.")
      else
        redirect_to(new_confirmation_path, alert: 'Please confirm your email first.')
      end
    else
      redirect_to(login_path, notice: "If that user exists we've sent instructions to their email.")
    end
  end

  def edit
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @user.nil?
      redirect_to(new_password_path, alert: 'Invalid or expired token.')
    end
  end

  def new; end

  def update
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @user
      if @user.update(password_params)
        @user.send_password_change_confirmation_email!
        redirect_to(login_path, notice: 'You can now login using your new password.')
      else
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render(:edit, status: :unprocessable_entity)
      end
    else
      flash.now[:alert] = 'Invalid or expired token.'
      render(:new, status: :unprocessable_entity)
    end
  end

  private

  def password_params
    # params.require(:user).permit(:password, :password_confirmation)
    params.require(:user).permit(:password)
  end
end
