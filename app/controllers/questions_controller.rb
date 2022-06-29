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
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("new_question",
                                                    partial: "questions/form",
                                                    locals: { question: @room.questions.build }
          )
        }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/:room_id/questions/1
  def update
    respond_to do |format|
      if @comment.update(update_question_params)
        format.turbo_stream
      else
        format.turbo_stream
      end
    end
  end

  # DELETE /rooms/:room_id/questions/1
  def destroy
    @event = Event.find(params[:id])

    if @question.user_id != current_user.id
      flash[:error] = 'You are not the owner of this event'
      redirect_to(events_path)
      return
    end
    if @question.destroy
      flash[:success] = 'Object was successfully deleted.'
      # redirect_to(events_path)
      # format.turbo_stream
    else
      flash[:error] = 'Something went wrong'
      # redirect_to(events_path)
      # format.turbo_stream
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
    params.require(:question).permit(:title)
  end

  def update_question_params 
    params.require(:question).permit(:title, :status)
  end
end
