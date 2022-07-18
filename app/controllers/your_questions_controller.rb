class YourQuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated
  
  def index
    # TODO: make sure the user is the only one enable to read the question
    # Pundit ;-)
    @questions = Question.where(user_id: current_user.id)
    @count = @questions.count
  end

  def show
    # TODO: make sure the user is the only one enable to read the question
    # Pundit ;-)
    @question = Question.find(id: params[:id])
  end
end
