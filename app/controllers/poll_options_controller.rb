class PollOptionsController < ApplicationController
  before_action :authenticate_user!

  # POST /polls/:poll_id/poll_options
  # Used to add a new poll_option to an existing poll.
  # When the poll allow add_option (true) the user can add a new poll_option
  # after casting their vote.
  # PollOption created by users are subject to moderation 
  def create
    # Retrieve the poll
    poll = Poll.find(params[:poll_id])
  
    # Check that users are allowed to add options
    # If not, we redirect to the poll with an error message
    if !poll.add_option
      logger.warn "User #{current_user.id} tried to add an option to poll #{poll.id}"
      redirect_to(poll_path(params[:poll_id]), alert: 'This poll does not allow users to add options.')
    end

    # Create a new PollOption
    poll_option = PollOption.create(poll_id: params[:poll_id], title: params[:title], user_id: current_user.id)
    
    if poll_option.save!
      # The user who creates the new option is automatically casting a positive vote for it.
      vote = Vote.find_or_create_by(user_id: current_user.id, votable_id: poll_option.id, votable_type: "PollOption")
      vote.up_vote!

      # Run automatic moderation
      ModeratePollOptionJob.perform_async(poll_option.to_json)

      # Redirect the poll stats
      redirect_to(poll_path(params[:poll_id]), notice: 'Your option will be added to the poll.')
    else
      redirect_to(poll_path(params[:poll_id]), alert: 'An error occured preveting your option from being added to the poll.')
    end
  end

end
