class PollsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  def index
    @polls = current_user.organization.polls.order(created_at: :desc).includes(:user)
  end

  def new
    @poll = current_user.organization.polls.new
    2.times { @poll.poll_options.build }
  end
  
  def create
    @poll = current_user.organization.polls.new(poll_params)
    @poll.user_id = current_user.id

    if @poll.save
      redirect_to polls_url, notice: "The poll was succesfully saved."
    else
      flash[:alert] = "An error prevented the poll from being created"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @poll = Poll.find(params[:id])

    if @poll.update(poll_params)
      redirect_to polls_url, notice: "The poll was succesfully updated."
    else
      flash[:alert] = "An error prevented the poll from being updated"
      render :edit, status: :unprocessable_entity
    end
  end

  def edit
    @poll = Poll.find(params[:id])
    authorize @poll
  end

  def show
    @poll = Poll.includes(:poll_options).where(poll_options: { status: PollOption.statuses[:approved] }).find(params[:id])
    authorize @poll

    @table_data = VoteCounterService.count_by_poll_option_and_choice(@poll)
    @user_votes = VoteCounterService.user_votes_for_poll(current_user, @poll)
  end

  def destroy
    @poll = current_user.organization.polls.find(params[:id])
    authorize @poll
    if @poll.destroy
      redirect_to polls_url, notice: "The poll was successfully deleted."
    else
      flash[:alert] = "An error prevented the poll from being deleted."
      redirect_to polls_url
    end
  end

  # GET /polls/user-stats
  def user_stats
    # Stats for the polls created by the user
    @created_polls_count = Poll.where(user_id: current_user.id).count
    @participation_count = PollParticipation.joins(:poll).where(polls: { user_id: current_user.id }).count
    @votes_count = Vote.joins("INNER JOIN poll_options ON votes.votable_id = poll_options.id")
            .where("votes.votable_type = 'PollOption' AND poll_options.poll_id IN (?)", 
            Poll.where(user_id: current_user.id).pluck(:id)).count


    # Stats for the polls the user participated in
    @participated_polls = PollParticipation.where(user_id: current_user.id).order(created_at: :desc)
    @casted_votes_count = Vote.where(user_id: current_user.id).count

    # Poll creation key dates
    @first_poll_date = current_user.polls.order(:created_at).first&.created_at
    @last_poll_date = current_user.polls.order(:created_at).last&.created_at

    # Poll participation key dates
    @first_vote_date = Vote.joins("INNER JOIN poll_options ON votes.votable_id = poll_options.id")
                      .where("votes.votable_type = 'PollOption' AND poll_options.poll_id IN (?)", 
                              Poll.where(user_id: current_user.id).pluck(:id))
                      .order(:created_at).first&.created_at

    @last_vote_date = Vote.joins("INNER JOIN poll_options ON votes.votable_id = poll_options.id")
                      .where("votes.votable_type = 'PollOption' AND poll_options.poll_id IN (?)", 
                              Poll.where(user_id: current_user.id).pluck(:id))
                      .order(:created_at).last&.created_at
 
  end

  private

  def poll_params
    params.require(:poll).permit(:add_option, :description,
      :display, :duration, :is_anonymous, :max_votes, :num_votes, 
      :poll_type, :status, :title, selectors: [],
      poll_options_attributes: [:id, :title, :status, :is_answer, :_destroy])
  end

end
