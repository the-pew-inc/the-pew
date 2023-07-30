class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization

  around_action :switch_timezone

  before_action :set_paper_trail_whodunnit

  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def switch_timezone(&action)
    Time.use_zone(timezone_from_cookies, &action)
  rescue TZInfo::UnknownTimezone, TZInfo::InvalidTimezoneIdentifier
    Time.zone
  end

  def timezone_from_cookies
    if cookies[:timezone].nil?
      return "Etc/UTC"
    else
      return cookies[:timezone]
    end
  end
end
