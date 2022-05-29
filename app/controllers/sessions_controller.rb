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
end
