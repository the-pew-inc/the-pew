class AsksController < ApplicationController
  def index
    
  end

  # POST /pin/1
  def validate_pin
    pin = params[:pin]
    @event = Event.find_by(short_code: pin)
    respond_to do |format|
      if @event
        format.html { redirect_to ask_root_path(@event), notice: "Welcome in!" }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :index, status: :unprocessable_entity, alert: "Invalid pin" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

end
