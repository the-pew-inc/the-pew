class YourQuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated
  
  def index
    # TODO: make sure the user is the only one enable to read the question
    # Pundit ;-)
    @questions = Question.where(user_id: current_user.id).order(created_at: :desc)
    @count = @questions.count
  end

  def show
    @question = current_user.questions.find(params[:id])
  end

end
