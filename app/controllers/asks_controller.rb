class AsksController < ApplicationController
  # GET (/1)
  def index
    # If pin is present as a parameter
    if params[:pin].present?
      pin = params[:pin]

      # Validate the PIN format first
      validate_pin_format(pin) and return

      # Search for the event with the given pin
      @event = Event.find_by(short_code: pin)

      respond_to do |format|
        if @event
          format.html { redirect_to(room_questions_path(@event.rooms.first), notice: 'Welcome in!') }
        else
          format.html { redirect_to(ask_root_path(@event), alert: 'Invalid PIN', status: :unprocessable_entity) }
        end
      end
    end
  end

  # GET /event/:event_id
  # Used to ilst all public and active rooms on the platform 
  def event_rooms
    @event = Event.find(params[:event_id])
    @rooms = @event.rooms
  end

  # POST /pin/1
  def validate_pin
    pin = params[:pin]

    # Validate the PIN format first
    validate_pin_format(pin) and return
    
    @event = Event.find_by(short_code: pin)

    respond_to do |format|
      if @event
        format.html { redirect_to(room_questions_path(@event.rooms.first.id), notice: 'Welcome in!') }
      else
        format.html { redirect_to(ask_root_path(@event), alert: 'Invalid PIN', status: :unprocessable_entity) }
      end
    end
  end

  private

  def validate_pin_format(pin)
    if pin.blank? || pin.length != 6 || (pin.is_a? Integer)
      flash.now[:alert] = "Invalid PIN format"
      redirect_to ask_root_path, status: 406 and return true
    end
  end
end
