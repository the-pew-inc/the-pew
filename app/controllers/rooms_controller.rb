class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  def index
    @event = Event.find(params[:id])
    @rooms = @event.rooms
  end
  
  def show
    @room = Room.find(params[:id])
    @question = @room.questions.beinganswered.first
    @questions = @room.questions.approved
    render :layout => 'display'
  end

end
