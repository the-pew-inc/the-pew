class VotesController < ApplicationController
  include ActionView::RecordIdentifier
  include ApplicationHelper

  before_action :authenticate_user!

  def show
    @vote = Vote.find_or_create_by(user_id: current_user.id, votable_id: params[:votable_id], votable_type: params[:votable_type])

    case params[:votable_type]
    when "Question"
      @vote.voted(params[:choice])
      @vote.broadcast_update_later_to(@vote.votable.room.id, target: "#{dom_id(@vote.votable)}_count", html: @vote.votable.up_votes)
    when "PollOption"
      @poll = Poll.find(params[:poll_id])
      @vote.poll_voted(@poll, current_user, params[:choice])
    else
      logger.info "No broadcast associated to #{params[:votable_type]} in votes_controller#show"
    end
  end

end
