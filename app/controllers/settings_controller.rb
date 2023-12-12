class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated
  before_action :set_organization_and_authorize

  layout 'settings'

  # GET /settings/
  def index
    if @organization
      @organization_id = @organization.id
      @user_count = @organization.members.count
      @organization_owner = current_user.member.owner?
    else
      flash[:alert] = 'You are not the owner of this organization'
      redirect_to(root_path)
    end
  end

  private

  def set_organization_and_authorize
    @organization = current_user.organization
    authorize(@organization, :index?, policy_class: SettingsPolicy)
  end
end
