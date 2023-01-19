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
    @account = Account.where(account_id: Member.where(user_id: current_user.id, owner: true).first.id).first
    @account_owner = true
  end

  # GET /organization/:id
  def show
    @account = Account.find(params[:id])
    # Shall be moved to another controller that only deals with the users who are part of an account
    # @account_users = User.where(user_id: User.where(user_id: Member.where(account_id: @account.id)).select(:user_id))
  end

  # PUT /organization/:id
  def update

  end

  private
end
