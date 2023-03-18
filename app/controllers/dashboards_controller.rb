class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  def show
    @questions = current_user.questions.order(created_at: :desc).limit(5)
    @status = current_user.questions.group(:status).count.any? ? current_user.questions.group(:status).count : {"asked"=>0, "approved"=>0, "beinganswered"=>0, "answered"=>0, "rejected"=>0}
    @total = @status.values.reduce(:+) || 0 # Sum all the questions
    @pew_points = 0

    # Call for @pew_points update
    update_pew_points
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

end
