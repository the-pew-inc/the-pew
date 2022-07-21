class VotesController < ApplicationController
  before_action :authenticate_user!

  def show
    @vote = Vote.find_or_create_by(user_id: current_user.id, votable_id: params[:votable_id], votable_type: params[:votable_type])
  
    voted(params[:choice])

    votable = @vote.votable
    target_name = [votable.room_id, votable.class.name.downcase.pluralize]
    Turbo::StreamsChannel.broadcast_update_later_to(target_name, target: "#{dom_id(votable)}_count", html: votable.vote_count)
  end

  private

  def voted(choice)
    return unless choice.in?(Vote::choices.keys)

    case choice
    when 'up_vote'
      @vote.up_vote? ? @vote.cancel! : @vote.up_vote!
    when 'down_vote'
      @vote.down_vote? ? @vote.cancel! : @vote.down_vote!
    end
  end

end
