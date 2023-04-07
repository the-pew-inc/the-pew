class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  layout "settings"

  # GET /settings/
  def index
    # TODO add a condition for when a user is an admin for the account. so that extraction of the organization will be something like current_user.member.organization
    # TODO add a second condition owner: true
    # Current code only displays account information when the user is the owner
    organization = Member.find_by(user_id: current_user.id, owner: true).organization
    logger.debug "ORGANIZATION ID: #{organization.id}"
    @organization_id = organization.id
    @user_count = organization.members.count
    @organization_owner = true
  end
end
