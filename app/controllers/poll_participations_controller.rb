class PollParticipationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_poll_and_table_data

  # POST /polls/:poll_id/poll_participations
  # Used to record user's participation to a poll/vote. Once a user
  # has participated to a poll/vote the user can no longer edit their
  # answers to that poll/vote. The poll_participations table is used to
  # track who participated and who did not, making it possible to send
  # reminders to users who are invited.
  def create
    respond_to do |format|
      if !PollParticipation.participated?(current_user, @poll)
        PollParticipation.create(user: current_user, poll: @poll)

        # Render for the current user
        format.turbo_stream { render :success, locals: { add_option: @poll.add_option } }
      else
        format.turbo_stream { render :errors }
      end
    end
  end
  
  private

  def set_poll_and_table_data
    @poll = Poll.find(params[:poll_id])
    @table_data = VoteCounterService.count_by_poll_option_and_choice(@poll)
    @user_votes = VoteCounterService.user_votes_for_poll(current_user, @poll)
  end
end
