class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  # POST /events/:event_id/rooms
  def create
    @event = Event.find(params[:event_id])
    @room = @event.rooms.new(room_params)

    # Flowbite Datepicker returns the date formatted as mm/dd/yyyy
    # This format must be aligned with the expected datetime (aka timestamp) used by ActiveRecord
    # Using Date.parse leads to strange result such as April 1st being converted to Jan 1st
    @room.start_date = Date.strptime(room_params[:start_date], "%m/%d/%Y")
    @room.end_date   = Date.strptime(room_params[:end_date], "%m/%d/%Y")

    if @room.save
      # Make the user the admin of the room
      current_user.add_role :admin, @room

      # Trigger the invitation if the room is not universal. Room type is tested in 
      # ResourceInviteService
      # params[:invited_users] is already a JSON so we pass it as it is to the next
      # steps as Sidekiq is expecting this format.
      ResourceInviteService.new(params[:invited_users], current_user.id, @room).create if !params[:invited_users].blank?

      redirect_to event_rooms_path(@event), notice: 'Room was successfully added to the event.'
    else
      flash[:alert] = "An error prevented the room from being created"
      render :new, status: :unprocessable_entity
    end

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
    @event = @room.event
  end

  # GET /events/:event_id/rooms
  def index
    @event = Event.find(params[:event_id])
    @rooms = @event.rooms.order(start_date: :asc).order(created_at: :asc)
  end

  # GET /events/:event_id/rooms/new
  def new
    @event = Event.find(params[:event_id])
    @room = @event.rooms.build

    # Align values with the event values
    @room.allow_anonymous = @event.allow_anonymous
    @room.end_date = @event.end_date
    @room.start_date = @event.start_date
  end
  
  def show
    @room = Room.find(params[:id])
    @question = @room.questions.beinganswered.first
    @questions = @room.questions.approved
    render :layout => 'display'
  end

  # PATCH or PUT /rooms/:id
  def update
    @room = Room.find(params[:id])

    # Flowbite Datepicker returns the date formatted as mm/dd/yyyy
    # This format must be aligned with the expected datetime (aka timestamp) used by ActiveRecord
    # Using Date.parse leads to strange result such as April 1st being converted to Jan 1st
    attributes = room_params.clone
    attributes[:start_date] = Date.strptime(room_params[:start_date], "%m/%d/%Y")
    attributes[:end_date]   = Date.strptime(room_params[:end_date], "%m/%d/%Y")

    # Update the invitation if the room is not universal. Room type is tested in 
    # ResourceInviteService
    # params[:invited_users] is already a JSON so we pass it as it is to the next
    # steps as Sidekiq is expecting this format.
    ResourceInviteService.new(params[:invited_users], current_user.id, @room).update if !params[:invited_users].blank?

    if @room.update(attributes)
      redirect_to event_rooms_path(@room.event), notice: 'Room was successfully updated.'
    else
      flash[:alert] = "An error prevented the room from being updated"
      render :new, status: :unprocessable_entity
    end

  end

  private

  def room_params
    params.require(:room).permit(:allow_anonymous, :description, :room_type, :name, :start_date, :status, :end_date)
  end

end
