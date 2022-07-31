class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated
  
  def index
    @notifications = Notification.where(recipient: current_user).order(created_at: :desc)
  end

  def mark_all_as_read
    current_user.notifications.mark_as_read!
    redirect_to notifications_path
  end

  def mark_as_read
    @notification = Notification.find(params[:id])
  end
end
