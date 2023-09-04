class QuestionAnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  before_action :set_question
  before_action :set_question_answer, only: [:edit, :update, :destroy]

  def new
    @question_answer = @question.build_answer
  end

  def create
    @question_answer = @question.build_answer(question_answer_params)
    if @question_answer.save
      # redirect_to or render turbo_stream
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @question_answer.update(question_answer_params)
      # redirect_to or render turbo_stream
    else
      render :edit
    end
  end

  def destroy
    @question_answer.destroy
    # redirect_to or render turbo_stream
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_question_answer
    @question_answer = @question.answer
  end

  def question_answer_params
    params.require(:question_answer).permit(:text_answer)
  end
end
