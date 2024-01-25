class EventsController < ApplicationController
  include Invitable

  before_action :authenticate_user!, only: %i[index edit destroy update new]
  before_action :redirect_if_unauthenticated, only: %i[index edit destroy update new]
  before_action :set_event, except: %i[index new create event validate_pin user_stats]
  before_action :authorize_event, only: %i[show edit update stats export destroy]

  def index
    @events = policy_scope(Event).includes(user: :profile).order(start_date: :desc)
  end

  # GET /events/:id
  def show
    # If there is only one default room, we redirect to that room.
    # If there is more than one room or if the room has a different name than __default__
    # we display the event show page
    return unless @event.rooms.count == 1 && @event.rooms.first.name.downcase == '__default__'

    redirect_to(room_questions_path(@event.rooms.first))
    nil
  end

  def new
    is_confirmed? and return

    @event = current_user.events.new
  end

  def edit
    @invited_users = fetch_invited_users(@event)
  end

  def create
    is_confirmed? and return

    @event = current_user.events.new(create_event_params)

    # Flowbite Datepicker returns the date formatted as mm/dd/yyyy
    # This format must be aligned with the expected datetime (aka timestamp) used by ActiveRecord
    # Using Date.parse leads to strange result such as April 1st being converted to Jan 1st
    @event.start_date = Date.strptime(create_event_params[:start_date], '%m/%d/%Y')
    @event.end_date   = Date.strptime(create_event_params[:end_date], '%m/%d/%Y')

    if @event.save
      # Make the user the admin of the event
      current_user.add_role(:admin, @event)

      # Trigger the invitation if the event is not universal. Event type is tested in
      # ResourceInviteService
      # params[:invited_users] is already a JSON so we pass it as it is to the next
      # steps as Sidekiq is expecting this format.
      ResourceInviteService.new(params[:invited_users], current_user.id, @event).create if params[:invited_users].present?

      # When a new event is create we attach a default room.
      room = @event.rooms.new
      room.name = '__default__'
      room.always_on = @event.always_on
      room.allow_anonymous = @event.allow_anonymous
      room.start_date = @event.start_date
      room.end_date = @event.end_date
      room.room_type = @event.event_type
      if room.save
        # Make the user the admin of the default room
        current_user.add_role(:admin, room)

        redirect_to(events_path, notice: 'Event was successfully created.')
      else
        flash[:alert] = 'An error prevented the event from being created'
        render(:new, status: :unprocessable_entity)
      end
    else
      flash[:alert] = 'An error prevented the event from being created'
      render(:new, status: :unprocessable_entity)
    end
  end

  # GET /event/:id/stats
  def stats
    @questions = Question.where(room_id: @event.rooms.first.id).order(status: :desc).order(created_at: :desc)
    @count = @questions.count
    return unless @count > 0

    @approved_count = @questions.approved.count
    @answered_count = @questions.answered.count
  end

  def update
    is_confirmed? and return

    @event = Event.find(params[:id])

    # Flowbite Datepicker returns the date formatted as mm/dd/yyyy
    # This format must be aligned with the expected datetime (aka timestamp) used by ActiveRecord
    # Using Date.parse leads to strange result such as April 1st being converted to Jan 1st
    attributes = update_event_params.clone
    attributes[:start_date] = Date.strptime(update_event_params[:start_date], '%m/%d/%Y')
    attributes[:end_date]   = Date.strptime(update_event_params[:end_date], '%m/%d/%Y')

    # Update the invitation if the event is not universal. Event type is tested in
    # ResourceInviteService
    # params[:invited_users] is already a JSON so we pass it as it is to the next
    # steps as Sidekiq is expecting this format.
    ResourceInviteService.new(params[:invited_users], current_user.id, @event).update if params[:invited_users].present?

    if @event.update(attributes)
      if @event.saved_changes?
        redirect_to(events_path, notice: 'Event was successfully updated.')
      else
        redirect_to(events_path, notice: 'No changes were made.')
      end
    else
      flash[:alert] = 'An error prevented the event from being created'
      render(:edit, status: :unprocessable_entity)
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
        format.html { redirect_to(root_path, alert: 'Invalid PIN', status: :unprocessable_entity) }
      end
    end
  end

  # GET /event/:id/export
  def export
    @room = @event.rooms.first

    @questions = Question.where(room_id: @room.id)

    respond_to do |format|
      format.xlsx do
        response.headers[
          'Content-Disposition'
        ] = "attachment; filename=event-#{DateTime.now.strftime('%d%m%Y%H%M')}.xlsx"
      end
    end
  end

  # GET /events/user_stats
  def user_stats
    # Fetch IDs of events created by the user
    user_event_ids = Event.where(user_id: current_user.id).pluck(:id)

    # Fetch room IDs of rooms associated with the user-created events
    room_ids_for_user_events = Room.where(event_id: user_event_ids).pluck(:id)

    # Number of questions (not rejected) asked on events created by the user
    questions_on_user_events = Question.where(room_id: room_ids_for_user_events).where.not(status: :rejected)
    @questions_on_user_events_count = questions_on_user_events.count

    # Number of votes collected by these questions
    @votes_on_user_event_questions_count = Vote.where(votable: questions_on_user_events).count

    # Stats for the events created by the user
    @created_events_count = user_event_ids.count

    # Questions asked by the user in any event
    @questions_asked_count = Question.where(user_id: current_user.id).count

    # Votes casted by the user for questions in any event
    @votes_on_questions_count = Vote.joins('INNER JOIN questions ON votes.votable_id = questions.id')
                                    .where("votes.votable_type = 'Question' AND questions.user_id = ?", current_user.id).count

    # Votes casted by the user for any votable type
    @total_votes_casted_by_user = Vote.where(user_id: current_user.id).count

    # Event creation key dates
    @first_event_date = current_user.events.order(:created_at).first&.created_at
    @last_event_date = current_user.events.order(:created_at).last&.created_at

    # Key dates related to the user's participation in events (via questions & votes)
    @first_question_date = Question.where(user_id: current_user.id).order(:created_at).first&.created_at
    @last_question_date = Question.where(user_id: current_user.id).order(:created_at).last&.created_at

    # @first_vote_date = Vote.where(votable_type: 'Question', user_id: current_user.id).order(:created_at).first&.created_at
    # @last_vote_date = Vote.where(votable_type: 'Question', user_id: current_user.id).order(:created_at).last&.created_at
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
        format.html { redirect_to(root_path, alert: "No event matches this pin number: #{pin}.", status: :unprocessable_entity) }
      end
    end
  end

  def destroy
    is_confirmed? and return

    @event = Event.find(params[:id])

    if @event.destroy
      flash.now[:success] = 'Object was successfully deleted.'
    else
      flash.now[:alert] = 'Something went wrong'
    end
    redirect_to(events_path)
  end

  private

  def authorize_event
    authorize(@event)
  end

  def rooms_by_blocks
    rooms.order('DATE(start_date), EXTRACT(HOUR FROM start_date), EXTRACT(MINUTE FROM start_date), name')
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def create_event_params
    params.require(:event).permit(:allow_anonymous, :always_on, :description, :event_type, :name, :public_description, :start_date, :status,
                                  :end_date
    )
  end

  def update_event_params
    params.require(:event).permit(:allow_anonymous, :always_on, :description, :event_type, :name, :public_description, :short_code, :start_date,
                                  :status, :end_date
    )
  end

  # Called to make sure a user's account is confirmed before they can create or edit an event.
  def is_confirmed?
    return if current_user.confirmed?

    flash[:alert] = 'You must confirm your email address before you can create or edit an event.'
    redirect_to(edit_account_path(current_user)) and return true
  end

  # Used to valide that the pin format is valid
  # Used by the show method
  def validate_pin_format(pin)
    return unless pin.blank? || pin.length != 6 || pin.is_a?(Integer)

    flash.now[:alert] = 'Invalid PIN format'
    redirect_to(root_path, status: :not_acceptable) and return true
  end
end
