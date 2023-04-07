class InvitesController < ApplicationController
  before_action :authenticate_user!, except: %i[edit update]
  before_action :redirect_if_unauthenticated, except: %i[edit update]

  # GET /invites/:id/edit
  # where :id is the signed_id sent to the user via email
  def edit
    if user_signed_in?
      redirect_to(root_path, notice: "This page is not accessible.")
      return
    end
    @user = User.find_signed(params[:id], purpose: :invite)
    if @user.profile.nil?
      @user.build_profile
    end
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

  # GET /invites
  # Instantiate an invite (@user)
  def new
    @user = User.new
    @user.build_profile
  end

  # Used to resend the invitation in case the user didn't receive it when 
  # first invited.
  def resend_invite
    @user = User.find(params[:id])
    @user.send_invite!
  end

  def update
    @user = User.find(params[:id])
    if @user.update(update_user_params)
      @user.invited!
      login(@user)
      redirect_to(root_path, notice: "You successfully logged in")
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  private

  def invite_user_params
    params.require(:user).permit(:email)
  end

  def update_user_params
    params.require(:user).permit(:password, profile_attributes: [:nickname])
  end

end
