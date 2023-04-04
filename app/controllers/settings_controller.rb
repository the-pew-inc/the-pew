class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  layout "settings"

  # GET /settings/
  def index
    # TODO add a condition for when a user is an admin for the account. so that extraction of the organization will be something like current_user.member.organization
    # Current code only displays account information when the user is the owner
    @organization_id = Member.find_by(user_id: current_user.id, owner: true).organization_id
    @organization_owner = true
  end
end
