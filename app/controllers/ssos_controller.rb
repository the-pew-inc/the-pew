class SsosController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated
  before_action :authorize_sso_access, only: %i[update show edit]
  before_action :set_organization

  layout 'settings'

  def show; end
  def edit; end

  def update
    if @organization.update(update_sso_params)
      render(:edit, status: :ok)
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  private

  def update_sso_params
    params.require(:organization).permit(:domain, :sso)
  end

  def set_organization
    @organization = Organization.find(params[:organization_id])
    @organization.name = nil if @organization.name === '__default__'
  end

  def authorize_sso_access
    organization = current_user.organization
    return if SsoPolicy.new(current_user, organization).allowed?

    redirect_to(subscriptions_path, alert: 'You need an active subscription to access this feature.')
  end
end
