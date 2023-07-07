class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  def show
    @questions = current_user.questions.order(created_at: :desc).limit(5).includes(room: :event)
    @status = current_user.questions.group(:status).count
    @status_tones = current_user.questions.group([:status, :tone]).count
    @total = @status.values.reduce(:+) || 0 # Sum all the questions
    @pew_points = current_user.profile.pew_points

    @positive = 0
    @neutral = 0
    @negative = 0

    # Fetch Food for thought
    @recommended_articles = FoodForThought.random_selection(nil, nil, 0.2)

    # Clean @status to make sure it contains the number of expected elements
    # and that nil is replaced by 0 where needed
    default_status_count
  end

  private

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
