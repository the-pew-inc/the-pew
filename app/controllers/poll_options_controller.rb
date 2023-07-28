class PollOptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    poll_option = PollOption.create(poll_id: params[:poll_id], title: params[:title], user_id: current_user.id)
    
    if poll_option.save!
      # The user who creates the new option is automatically casting a positive vote for it.
      vote = Vote.find_or_create_by(user_id: current_user.id, votable_id: poll_option.id, votable_type: "PollOption")
      vote.up_vote!

      # Redirect the poll stats
      redirect_to(poll_path(params[:poll_id]), notice: 'Your option will be added to the poll.')
    else
      redirect_to(poll_path(params[:poll_id]), alert: 'An error occured preveting your option from being added to the poll.')
    end
  end

end
