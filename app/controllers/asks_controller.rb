class AsksController < ApplicationController
  def index 
  end

  # POST /pin/1
  def validate_pin
    pin = params[:pin]

    # Validate the PIN format first
    if !is_pin_format_valid(pin)
      flash[:alert] = "Invalid PIN format"
      redirect_to ask_root_path, status: 406
      return
    end
    
    @event = Event.find_by(short_code: pin)

    respond_to do |format|
      if @event
        format.html { redirect_to(ask_root_path(@event), notice: 'Welcome in!') }
        format.json { render(:show, status: :created, location: @event) }
      else
        format.html { redirect_to(ask_root_path(@event), alert: 'Invalid PIN') }
        format.json { render(json: @event.errors, status: :unprocessable_entity) }
      end
    end
  end

  private

  def is_pin_format_valid(pin)
    return false if pin.blank?
    return false if pin.length != 6
    # return false if pin.match(/[^0-9]/)
    return false if pin.is_a? Integer
    return true
  end
end
