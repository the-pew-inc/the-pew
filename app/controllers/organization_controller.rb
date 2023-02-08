# account routes as used to manage the USER ACCOUNT (users_controller)
# so the
class OrganizationController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated
  before_action :set_organization

  # DELETE /organization/:id
  def destroy
    # Not yet implemented / but should be a soft delete and keep data for like 30 days
  end

  # GET /organization/:id/edit
  def edit
    # TODO add a condition for when a user is an admin for the account.
    # Current code only displays account information when the user is the owner
    @organization.name = nil if @organization.name === "__default__"
  end

  # GET /organization/:id
  # TODO make it API only as the app is using the edit form
  def show
    # @account = Account.find(params[:id])
  end

  # PUT /organization/:id
  def update
    
    if ((update_organization_params[:name].nil? || update_organization_params[:name].strip.length == 0) && @organization.name.nil?)
      @organization.name = "__default__"
    end

    if @organization.update(update_organization_params)
      render :edit, status: :ok
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def update_organization_params
    params.require(:organization).permit(:name, :website, :description, :logo)
  end

  def set_organization
    @organization = Organization.find(params[:id])
  end
end
