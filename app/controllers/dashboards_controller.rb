class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  def show
    @questions = current_user.questions.order(created_at: :desc).limit(5).includes(room: :event)
    @status = current_user.questions.group(:status).count
    @status_tones = current_user.questions.group([:status, :tone]).count
    @total = @status.values.reduce(:+) || 0 # Sum all the questions
    @pew_points = 0

    @positive = 0
    @neutral = 0
    @negative = 0

    # Call for @pew_points update
    update_pew_points

    # Clean @status to make sure it contains the number of expected elements
    # and that nil is replaced by 0 where needed
    default_status_count
  end

  private

  # TODO: move it to a scheduled task or a counting cache
  def update_pew_points
    @questions.each do |question|
      @votes = question.votes 
      if @votes.count > 0
        c = @votes.group(:choice).count
        @pew_points = @pew_points + c['up_vote']
      end
    end
  end

  def default_status_count
    if @status.empty?
      @status = {"asked"=>0, "approved"=>0, "beinganswered"=>0, "answered"=>0, "rejected"=>0}
    else
      @status['asked']         = 0 if @status['asked'].nil?
      @status['approved']      = 0 if @status['approved'].nil?
      @status['beinganswered'] = 0 if @status['beinganswered'].nil?
      @status['answered']      = 0 if @status['answered'].nil?
      @status['rejected']      = 0 if @status['rejected'].nil?
    end
  end

end
