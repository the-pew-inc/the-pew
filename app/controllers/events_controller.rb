class EventsController < ApplicationController
  before_action :authenticate_user!, only: %i[index edit destroy update new]
  before_action :redirect_if_unauthenticated, only: %i[index edit destroy update new]
  before_action :set_event, except: %i[index new create event validate_pin]
  before_action :authorize_event, only: [:show, :edit, :update, :stats, :export, :destroy]

  def index
    @events = policy_scope(Event).includes(user: :profile).order(start_date: :desc)
  end

  def new
    is_confirmed? and return

    @event = current_user.events.new
  end

  def create
    is_confirmed? and return

    @event = current_user.events.new(create_event_params)

    # Flowbite Datepicker returns the date formatted as mm/dd/yyyy
    # This format must be aligned with the expected datetime (aka timestamp) used by ActiveRecord
    # Using Date.parse leads to strange result such as April 1st being converted to Jan 1st
    @event.start_date = Date.strptime(create_event_params[:start_date], "%m/%d/%Y")
    
    respond_to do |format|
      if @event.save
        # Make the user the admin of the event
        current_user.add_role :admin, @event

        # When a new event is create we attach a default room.
        room = @event.rooms.new
        room.name = '__default__'
        room.always_on = @event.always_on
        room.allow_anonymous = @event.allow_anonymous
        room.start_date = @event.start_date
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
    @event.start_date = @event.start_date.strftime("%m/%d/%Y")
  end

  def edit
    @event.start_date = @event.start_date.strftime("%m/%d/%Y")
  end

  # GET /event/:id/stats
  def stats
    @questions = Question.where(room_id: @event.rooms.first.id).order(status: :desc).order(created_at: :desc)
    @count = @questions.count
    if @count > 0 
      @approved_count = @questions.approved.count
      @answered_count = @questions.answered.count
    end
  end

  def update
    is_confirmed? and return

    @event = Event.find(params[:id])

    # Flowbite Datepicker returns the date formatted as mm/dd/yyyy
    # This format must be aligned with the expected datetime (aka timestamp) used by ActiveRecord
    # Using Date.parse leads to strange result such as April 1st being converted to Jan 1st
    attributes = update_event_params.clone
    attributes[:start_date] = Date.strptime(update_event_params[:start_date], "%m/%d/%Y")

    respond_to do |format|
      if @event.update(attributes)
        # Update the default room (if it exists)
        @room = Room.where(event_id: @event.id, name: '__default__').first
        if @room
          @room.always_on = update_event_params[:always_on]
          @room.allow_anonymous = update_event_params[:allow_anonymous]
          @room.start_date = @event.start_date

          if @room.save
            format.turbo_stream
          else 
            render :edit, status: :unprocessable_entity
          end
        else
          format.turbo_stream
        end
      else
        # format.turbo_stream
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def event
    pin = params[:pin].strip

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

  # GET /event/:id/export
  def export
    @room  = @event.rooms.first

    @questions = Question.where(room_id: @room.id)

    respond_to do |format|
      format.xlsx {
        response.headers[
          'Content-Disposition'
        ] = "attachment; filename=event-#{DateTime.now.strftime("%d%m%Y%H%M")}.xlsx"
      }
    end
  end

  # POST /
  def validate_pin
    pin = params[:pin].strip

    # Validate the PIN format first
    validate_pin_format(pin) and return
    
    @event = Event.find_by(short_code: pin)

    respond_to do |format|
      if @event
        format.html { redirect_to(room_questions_path(@event.rooms.first.id), notice: 'Welcome in!') }
      else
        format.html { redirect_to(root_path(), alert: "No event matches this pin number: #{pin}.", status: :unprocessable_entity) }
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

  def set_event
    @event = Event.find(params[:id])
  end

  def authorize_event
    authorize @event
  end

  def create_event_params
    params.require(:event).permit(:allow_anonymous, :always_on, :description, :event_type, :name, :start_date, :status, :stop_date)
  end

  def update_event_params
    params.require(:event).permit(:allow_anonymous, :always_on, :description, :event_type, :name, :short_code, :start_date, :status, :stop_date)
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
      redirect_to root_path, status: 406 and return true
    end
  end
end
