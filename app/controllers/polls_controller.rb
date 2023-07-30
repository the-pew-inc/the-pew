class PollsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  def index
    @polls = current_user.organization.polls.order(created_at: :desc).includes(:user)
    authorize @polls
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
    # @poll = Poll.find(params[:id])
    @poll = Poll.includes(:poll_options).where(poll_options: { status: PollOption.statuses[:approved] }).find(params[:id])
    authorize @poll

    @table_data = VoteCounterService.count_by_poll_option_and_choice(@poll)
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

  private

  def poll_params
    params.require(:poll).permit(:add_option, :description,
      :display, :duration, :is_anonymous, :max_votes, :num_votes, 
      :poll_type, :status, :title, selectors: [],
      poll_options_attributes: [:id, :title, :status, :is_answer, :_destroy])
  end

end
