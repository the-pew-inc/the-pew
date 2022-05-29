class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :destroy, :update]
  before_action :redirect_if_authenticated, only: [:create, :new]

  def create
    @user = User.new(create_user_params)
    if @user.save
      @user.send_confirmation_email!
      redirect_to root_path, notice: "Please check your email for confirmation instructions."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    reset_session
    redirect_to root_path, notice: "Your account has been deleted."
  end

  def edit
    @user = current_user
    @active_sessions = @user.active_sessions.order(created_at: :desc)
  end

  def new
    @user = User.new
    @user.build_profile
  end

  def update
    @user = current_user
    @active_sessions = @user.active_sessions.order(created_at: :desc)
    msg = "Account updated successfully." # default message

    # If the user's account is locked, do nothing but warn them
    if !@user.locked
      # If the user is updating their email, send a confirmation email and adavise them to check their email
      if update_user_params[:email].present?
        msg = "Email & account updated successfully. Please check your mail for confirmation instructions."
      end

      # Make sure that current_password and password are present if the user is updating their password
      if update_user_params[:password].present? && update_user_params[:current_password].present?
        # Validate the current password
        if !@user.authenticate(update_user_params[:current_password])
          flash.now[:alert] = "The current password you entered is incorrect."
          render :edit, status: :unprocessable_entity
          return
        end
      end

      # Save the user's changes
      if @user.update(update_user_params)
        @user.send_confirmation_email! unless !update_user_params[:email].present?
        redirect_to root_path, notice: msg
      else
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Your account has been locked. Please contact support."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def create_user_params
    params.require(:user).permit(:email, :password, :nickname, :remember_me, profile_attributes: [:id, :nickname])
  end

  def update_user_params
    params.require(:user).permit(:email, :nickname, :current_password, :password, profile_attributes: [:id, :nickname])
  end

end
