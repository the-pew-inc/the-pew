class YourQuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated
  
  def index
    @questions = current_user.questions.order(created_at: :desc)
    @count = @questions.count
  end

  def show
    @question = current_user.questions.find(params[:id])
  end

end
