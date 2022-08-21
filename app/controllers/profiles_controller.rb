class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  def edit; end

  def update
    if !@profile.update(profile_params)
      render(:edit, status: :unprocessable_entity)
    end
  end

  private
  
  def profile_params
    params.require(:profile).permit(:nickname, :mode)
  end

  def set_profile
    @profile = Profile.find_by(id: params[:id])
    if !@profile
      redirect_to root_path, alert: "This profile does not exist"
      return
    end

    if current_user.id != @profile.user_id
      redirect_to edit_profile_path(current_user), alert: "You can only edit your own profile"
      return
    end
  end
end
