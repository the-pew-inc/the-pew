class ResourceInvitesController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  def index; end

  def show; end

  def new
    @resource_invite = ResourceInvites.new
    @resource_invite.user_id = current_user.id
    @resource_invite.organization_id = current_user.organization.id
  end

  def edit; end
  def create; end

  def update; end

  def destroy; end
end
