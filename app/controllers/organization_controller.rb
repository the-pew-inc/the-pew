# account routes as used to manage the USER ACCOUNT (users_controller)
# so the
class OrganizationController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  # DELETE /organization/:id
  def destroy
    # Not yet implemented / but should be a soft delete and keep data for like 30 days
  end

  # GET /organization/:id/edit
  def edit
    # TODO add a condition for when a user is an admin for the account.
    # Current code only displays account information when the user is the owner
    @organization = Organization.find(params[:id])
    @organization_owner = true
  end

  # GET /organization/:id
  # TODO make it API only as the app is using the edit form
  def show
    # @account = Account.find(params[:id])
  end

  # PUT /organization/:id
  def update

  end

  # Organization related routes

  # GET /organization/:id/users
  # List all organization users (aka users who belong to an organization)
  def users
    @users = User.where(user_id: Member.where(organization_id: params[:id]).select(:user_id))
  end

  # GET /organization/:id/sso
  # Single Sign On
  def sso

  end

  private
end
