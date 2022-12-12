class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated
  
  def show
    @room = Room.find(params[:id])
    @question = @room.questions.beinganswered.first
    render :layout => 'display'
  end

end
