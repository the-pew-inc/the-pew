class PollsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  def index
    @polls = current_user.organization.polls.includes(:user)
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
  end

  def show
    @poll = Poll.find(params[:id])
    @labels = []
    @data = []
    poll_stats
  end

  def destroy
    @poll = current_user.organization.polls.find(params[:id])
    if @poll.destroy
      redirect_to polls_url, notice: "The poll was successfully deleted."
    else
      flash[:alert] = "An error prevented the poll from being deleted."
      redirect_to polls_url
    end
  end

  private

  def poll_params
    params.require(:poll).permit(:add_option, :poll_type, :status, :title, 
      :duration, :display, :description,
      poll_options_attributes: [:id, :title, :_destroy])
  end

  def poll_stats
    stats = Vote.joins("INNER JOIN poll_options ON votes.votable_id = poll_options.id AND votes.votable_type = 'PollOption'").where(poll_options: { id: @poll.poll_option_ids }).group('poll_options.title').count
    stats.each do |item|
      @labels << item[0]
      @data << item[1]
    end
  end

end
