class WelcomeController < ApplicationController
  def index; end

  # POST /pin/1
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

  private

  def validate_pin_format(pin)
    if pin.blank? || pin.length != 6 || (pin.is_a? Integer)
      flash.now[:alert] = "Invalid PIN format"
      redirect_to root_path, status: 406 and return true
    end
  end

end
