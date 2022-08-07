class VotesController < ApplicationController
  include ActionView::RecordIdentifier
  include ApplicationHelper

  before_action :authenticate_user!

  def show
    @vote = Vote.find_or_create_by(user_id: current_user.id, votable_id: params[:votable_id], votable_type: params[:votable_type])
  
    @vote.voted(params[:choice])
    
  end

end
