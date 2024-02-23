class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization

  around_action :switch_timezone

  before_action :set_paper_trail_whodunnit

  # after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    if current_user&.organization&.active_subscription?
      redirect_to(root_path, alert: 'You are not authorized to perform this action.')
    else
      redirect_to(subscriptions_path, alert: 'You need an active subscription to access this feature.')
    end
  end

  def switch_timezone(&)
    Time.use_zone(timezone_from_cookies, &)
  rescue TZInfo::UnknownTimezone, TZInfo::InvalidTimezoneIdentifier
    Time.zone
  end

  def timezone_from_cookies
    return 'Etc/UTC' if cookies[:timezone].nil?

    cookies[:timezone]
  end
end
