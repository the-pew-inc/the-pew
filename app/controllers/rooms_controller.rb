class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  # POST /events/:event_id/rooms
  def create

  end

  # DELETE /rooms/:id
  # There must be at least one room in an event
  def destroy
    @room = Room.find(params[:id])
    @event = @room.event
    
    if @event.rooms.count > 1
      @room.destroy
      redirect_to event_rooms_path(@event), notice: 'Room was successfully deleted.'
    else
      redirect_to event_rooms_path(@event), alert: 'Cannot delete the last room of an event.'
    end
  end

  # GET /rooms/:id/edit
  def edit
    @room = Room.find(params[:id])
  end

  # GET /events/:event_id/rooms
  def index
    @event = Event.find(params[:event_id])
    @rooms = @event.rooms
  end

  # GET /events/:event_id/rooms/new
  def new
    @event = Event.find(params[:event_id])
    @room = @event.rooms.build
  end
  
  def show
    @room = Room.find(params[:id])
    @question = @room.questions.beinganswered.first
    @questions = @room.questions.approved
    render :layout => 'display'
  end

  # PATCH or PUT /rooms/:id
  def update
  end

end
