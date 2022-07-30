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
    # TODO: make sure the user is the only one enable to read the question
    # Pundit ;-)
    @question = Question.find(params[:id])
  end

  def destroy
    # TODO: make sure the user is the only one enable to read the question
    # Pundit ;-)
    @question = Question.find(params[:id])

    if @question.destroy
      flash[:notice] = 'Question successfully deleted.'
    else
      flash[:alert] = 'An error occured while trying to delete the question'
    end
    redirect_to(your_questions_path)
  end
end
