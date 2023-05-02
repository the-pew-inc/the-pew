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
  end

  def destroy
  end

  private

  def poll_params
    params.require(:poll).permit(:add_option, :poll_type, :status, :title, 
      :duration, :display, :description,
      poll_options_attributes: [:id, :title, :_destroy])
  end

end
