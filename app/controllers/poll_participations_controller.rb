class PollParticipationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_poll

  # POST /poll_participations
  def create
    respond_to do |format|
      if !PollParticipation.participated?(current_user, @poll)
        PollParticipation.create(user: current_user, poll: @poll)

        format.turbo_stream { render :success, locals: { add_option: @poll.add_option } }
      else
        format.turbo_stream { render :errors }
      end
    end
  end
  
  private

  def set_poll
    @poll = Poll.find(params[:poll_id])
    @table_data = VoteCounterService.count_by_poll_option_and_choice(@poll)
  end
end
