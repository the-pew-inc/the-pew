class QuestionsController < ApplicationController
  before_action :set_question, only: %i[show edit update destroy]
  before_action :set_room

  # GET /rooms/:room_id/questions
  def index
    @questions = Question.questions_for_room(params[:room_id])
  end

  # GET /rooms/:room_id/questions/1
  def show; end

  # GET /rooms/:room_id/questions/new
  def new
    @question = @room.questions.build
  end

  # GET /rooms/:room_id/questions/1/edit
  def edit; end

  # POST /rooms/:room_id/questions
  def create
    @question = @room.questions.build(question_params)
    @question.user_id = current_user.id

    respond_to do |format|
      if @question.save
        format.html { redirect_to(question_url(@question), notice: 'Question was successfully created.') }
        format.json { render(:show, status: :created, location: @question) }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @question.errors, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /rooms/:room_id/questions/1
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to(question_url(@question), notice: 'Question was successfully updated.') }
        format.json { render(:show, status: :ok, location: @question) }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @question.errors, status: :unprocessable_entity) }
      end
    end
  end

  # DELETE /rooms/:room_id/questions/1
  def destroy
    @question.destroy

    respond_to do |format|
      format.html { redirect_to(questions_url, notice: 'Question was successfully destroyed.') }
      format.json { head(:no_content) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_question
    @question = Question.find(params[:id])
  end

  def set_room
    @room = Room.find(params[:room_id])
  end

  # Only allow a list of trusted parameters through.
  def question_params
    params.require(:question).permit(:title, :user_id)
  end
end
