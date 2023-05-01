class PollsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  def index
    @polls = current_user.organization.polls
  end

  def new
  end
  
  def create
  end

  def update
  end

  def edit
  end

  def show
  end

  def destroy
  end

end
