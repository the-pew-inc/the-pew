class PollOptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    poll_option = PollOption.create(poll_option_params)
    poll_option.poll_id = params[:id]
    poll_option.user_id = current_user.id
  end

  private

  def poll_option_params
    params.require(:poll_option).permit(:title)
  end

end
