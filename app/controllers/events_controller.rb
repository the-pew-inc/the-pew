class EventsController < ApplicationController
  before_action :authenticate_user!
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
        # Make the user the admin of the event
        current_user.add_role :admin, @event

        # When a new event is create we attach a default room.
        room = @event.rooms.new
        room.name = '__default__'
        if room.save
          # Make the user the admin of the default room
          current_user.add_role :admin, room

          format.html { redirect_to events_path, notice: "Event was successfully created." }
          format.turbo_stream
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show
    pin = params[:id].strip

    # Validate the PIN format first
    validate_pin_format(pin) and return

    # Search for the event with the given pin
    @event = Event.find_by(short_code: pin)

    respond_to do |format|
      if @event
        format.html { redirect_to(room_questions_path(@event.rooms.first), notice: 'Welcome in!') }
      else
        format.html { redirect_to(root_path(), alert: 'Invalid PIN', status: :unprocessable_entity) }
      end
    end

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
        # format.turbo_stream
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    is_confirmed? and return

    @event = Event.find(params[:id])
    if @event.user_id != current_user.id
      flash[:alert] = 'You are not the owner of this event'
      redirect_to(events_path)
      return
    end

    respond_to do |format|
      if @event.destroy
        flash.now[:success] = 'Object was successfully deleted.'
        format.html { redirect_to events_path }
        format.turbo_stream 
      else
        flash.now[:alert] = 'Something went wrong'
        # redirect_to(events_path)
        # format.turbo_stream
      end
    end
  end

  private

  def create_event_params
    params.require(:event).permit(:user_id, :name, :start_date, :stop_date, :event_type, :status, :always_on, :allow_anonymous)
  end

  def update_event_params
    params.require(:event).permit(:name, :start_date, :stop_date, :event_type, :status, :short_code, :always_on, :allow_anonymous)
  end

  # Called to make sure a user's account is confirmed before they can create or edit an event.
  def is_confirmed?
    if !current_user.confirmed?
      flash[:alert] = 'You must confirm your email address before you can create or edit an event.'
      redirect_to(edit_account_path(current_user)) and return true
    end
  end

  # Used to valide that the pin format is valid
  # Used by the show method
  def validate_pin_format(pin)
    if pin.blank? || pin.length != 6 || (pin.is_a? Integer)
      flash.now[:alert] = "Invalid PIN format"
      redirect_to ask_root_path, status: 406 and return true
    end
  end
end
