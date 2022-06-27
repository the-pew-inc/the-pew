class EventsController < ApplicationController
  before_action :authenticate_user!, only: %i[edit destroy update new create]
  before_action :redirect_if_unauthenticated

  def index
    @events = Event.where(user_id: current_user.id).order(start_date: :desc)
  end

  def new
    is_confirmed? and return

    @event = current_user.events.new
  end

  def create
    is_confirmed? and return

    @event = current_user.events.new(create_event_params)
    
    respond_to do |format|
      if @event.save
        # When a new event is create we attach a default room.
        room = @event.rooms.new
        room.name = '__default__'
        if room.save
          # format.html { redirect_to events_path, notice: "Event was successfully created." }

          # Set the current user as admin for the event and the room
          current_user.add_role :admin, @event.id
          current_user.add_role :admin, room.id

          format.turbo_stream {
            render turbo_stream: turbo_stream.replace("new_event",
                                                      partial: "events/form",
                                                      locals: { event: Event.new }
            )
          }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    is_confirmed? and return

    @event = Event.find(params[:id])
    respond_to do |format|
      if @event.update(update_event_params)
        format.turbo_stream
      else
        format.turbo_stream
      end
    end
  end

  def destroy
    is_confirmed? and return

    @event = Event.find(params[:id])
    if @event.user_id != current_user.id
      flash[:error] = 'You are not the owner of this event'
      redirect_to(events_path)
      return
    end
    if @event.destroy
      flash[:success] = 'Object was successfully deleted.'
      # redirect_to(events_path)
      format.turbo_stream
    else
      flash[:error] = 'Something went wrong'
      # redirect_to(events_path)
      format.turbo_stream
    end
  end

  private

  def create_event_params
    params.require(:event).permit(:user_id, :name, :start_date, :stop_date, :event_type, :status)
  end

  def update_event_params
    params.require(:event).permit(:name, :start_date, :stop_date, :event_type, :status, :short_code)
  end

  # Called to make sure a user's account is confirmed before they can create or edit an event.
  def is_confirmed?
    if !current_user.confirmed?
      flash[:alert] = 'You must confirm your email address before you can create or edit an event.'
      redirect_to(edit_account_path(current_user)) and return true
    end
  end
end
