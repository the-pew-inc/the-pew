# account routes are used to manage the USER ACCOUNT
# Users are managed from the settings section of the application 
# via the users_controller. The index section displays all the users that are part
# of this organization.
class OrganizationController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated
  before_action :set_organization
  before_action :authorize_organization, only: [:show, :edit, :update]

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

  def upload_logo
    @organization = Organization.find(params[:id])
    if @organization.update(logo_params)
      # Simply render the view for a successful update. 
      # The contents of the turbo-frame "logo_frame" will get replaced.
      render :upload_logo
    else
      # If there's an error with the update, let's set a flash message. 
      # You can also choose to directly display an error within the turbo frame if preferred.
      flash.now[:alert] = "Failed to upload logo. Please try again."
      render :upload_logo
    end
  end

  private
  def update_organization_params
    params.require(:organization).permit(:name, :website, :description)
  end

  def logo_params
    params.require(:organization).permit(:logo)
  end

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def authorize_organization
    authorize @organization
  end
end
