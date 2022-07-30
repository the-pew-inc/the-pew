class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated
  
  def index
    @notifications = Notification.where(recipient: current_user).order(created_at: :desc)
  end
end
