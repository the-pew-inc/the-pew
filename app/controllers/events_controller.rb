class EventsController < ApplicationController
  before_action :authenticate_user!, only: %i[edit destroy update new create]
  before_action :redirect_if_unauthenticated

  def index
    @events = Event.where(user_id: current_user.id).order(start_date: :desc)
  end

  def new
    @event = current_user.events.new
  end

  def create
    @event = current_user.events.new(create_event_params)
    # @event.user_id = current_user.id
    if @event.save
      # generate a default room.
      room = @event.rooms.new
      room.name = '__default__'
      room.save!
      redirect_to(@event)
    else
      render(:new)
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(update_event_params)
      redirect_to(@event)
    else
      render(:edit)
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if @event.user_id != current_user.id
      flash[:error] = 'You are not the owner of this event'
      redirect_to(events_path)
      return
    end
    if @event.destroy
      flash[:success] = 'Object was successfully deleted.'
      redirect_to(events_path)
    else
      flash[:error] = 'Something went wrong'
      redirect_to(events_path)
    end
  end

  private

  def create_event_params
    params.require(:event).permit(:user_id, :name, :start_date, :stop_date, :event_type, :status)
  end

  def update_event_params
    params.require(:event).permit(:name, :start_date, :stop_date, :event_type, :status, :short_code)
  end
end
