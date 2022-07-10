class YourQuestionsController < ApplicationController
  def index
    @questions = Question.where(user_id: current_user.id)
    @count = @questions.count
  end

  def show
    @question = Question.find(id: params[:id])
  end
end
