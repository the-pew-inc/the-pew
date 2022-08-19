# app/controllers/concerns/authentication.rb
module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :current_user
    helper_method :current_user
    helper_method :user_signed_in?
  end

  def authenticate_user!
    store_location
    redirect_to(login_path, alert: 'You need to login to access that page.') unless user_signed_in?
  end

  def login(user)
    cookies_accepted = are_cookies_accepted?
    reset_session
    active_session = user.active_sessions.create!(user_agent: request.user_agent, ip_address: request.ip)
    session[:current_active_session_id] = active_session.id
    session[:cookies_accepted] = cookies_accepted

    ahoy.authenticate(user)

    active_session
  end

  def logout
    cookies_accepted = are_cookies_accepted?
    active_session = ActiveSession.find_by(id: session[:current_active_session_id])
    reset_session
    active_session.destroy! if active_session.present?
    session[:cookies_accepted] = cookies_accepted
  end

  def redirect_if_authenticated
    redirect_to(root_path, alert: 'You are already logged in.') if user_signed_in?
  end

  def redirect_if_unauthenticated
    redirect_to(root_path, alert: 'You need to login to access that page.') unless user_signed_in?
  end

  def current_user
    Current.user = if session[:current_active_session_id].present?
                     ActiveSession.find_by(id: session[:current_active_session_id])&.user
                   elsif cookies.permanent.encrypted[:remember_token].present?
                     ActiveSession.find_by(remember_token: cookies.permanent.encrypted[:remember_token])&.user
                   end
  end

  def user_signed_in?
    Current.user.present?
  end

  # Remember me feature
  def forget(user)
    cookies.delete(:remember_token)
    user.regenerate_remember_token
  end

  def remember(active_session)
    cookies.permanent.encrypted[:remember_token] = active_session.remember_token
  end

  # Active Session feature
  def forget_active_session
    cookies.delete(:remember_token)
  end

  # Private methods
  private

  def store_location
    session[:user_return_to] = request.original_url if request.get? && request.local?
  end

  def are_cookies_accepted?
    if session[:cookies_accepted]
      return true
    end
    return false
  end

end
