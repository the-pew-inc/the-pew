class QuestionAnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  before_action :set_question
  before_action :set_question_answer, only: [:edit, :update, :destroy]

  def new
    @question_answer = @question.build_answer
  end

  def create
    @question_answer = @question.build_answer(question_answer_params.merge(user: current_user))
    if @question_answer.save
      # Broadcasting the updated question
      Broadcasters::Questions::Updated.new(@question).call

      redirect_to room_questions_path(@question.room)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @question_answer.update(question_answer_params)
      # Broadcasting the updated question
      Broadcasters::Questions::Updated.new(@question).call

      redirect_to room_questions_path(@question.room)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @question_answer.destroy
      # Broadcasting the updated question
      Broadcasters::Questions::Updated.new(@question).call

      flash[:notice] = "The answer was successfully deleted."
      redirect_to room_questions_path(@question.room)
    else
      render :edit, status: :unprocessable_entity
    end
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
