class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  def show
    @questions = current_user.questions.order(created_at: :desc).limit(5)
    @status = current_user.questions.group(:status).count
    @total = @status.values.reduce(:+) # Sum all the questions
  end
end
