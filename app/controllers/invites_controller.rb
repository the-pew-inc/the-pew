class InvitesController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  # GET /invites
  # Instantiate an invite (@user)
  def new
    @user = User.new
    @user.build_profile
  end

  # POST /invites
  # Send invitation email to users who are invoted to join an organization
  # or invited to join an invite only event
  def create
    @user = User.new(invite_user_params)
    @user.invited_at = Time.current
    @user.invited = true

    respond_to do |format|
      if @user.save
        # Save user to the correct organization, aka current_user.organization
        member = Member.new
        member.organization_id = current_user.organization.id
        member.user_id = @user.id
        member.save!

        # Send email to the user
        @user.send_invite!

        # Return a success message in flash
        format.html { redirect_to new_invite_url, notice: "User was successfully invited." }
        format.json { render :show, status: :created, location: @user }
      else
        flash[:alert] = "User #{@user.email} was not invited."
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Used to resend the invitation in case the user didn't receive it when 
  # first invited.
  def resend_invite
    @user = User.find(params[:id])
    @user.send_invite!
  end

  private

  def invite_user_params
    params.require(:user).permit(:email)
  end

end
