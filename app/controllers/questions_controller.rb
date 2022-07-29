class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[edit destroy update new]
  
  before_action :set_question, only: %i[show edit update destroy]
  before_action :set_room

  # GET /rooms/:room_id/questions
  def index
    if @room.event.universal?
      @questions = Question.questions_for_room(params[:room_id]).by_recently_created
    else
      redirect_to room_path, alert: "This event is private"
    end
  end

  # GET /rooms/:room_id/questions/1
  def show 
    if request.headers["turbo-frame"]
      render partial: 'question', locals: { question: @question }
    else
      render 'show'
    end
  end

  # GET /rooms/:room_id/questions/new
  def new
    @question = @room.questions.build
  end

  # GET /rooms/:room_id/questions/1/edit
  def edit; end

  # POST /rooms/:room_id/questions
  def create
    @question = @room.questions.build(create_question_params)

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
      if @question.update(update_question_params)
        format.turbo_stream
      else
        format.turbo_stream
      end
    end
  end

  # DELETE /rooms/:room_id/questions/1
  def destroy
    @question = Question.find(params[:id])

    if @question.user_id != current_user.id
      flash[:alert] = 'You are not the owner of this question'
      redirect_to room_questions_path, status: :unprocessable_entity
      return
    end

    @question.destroy
    # TODO: better handle the error (need turbo stream flash support)
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
  def create_question_params
    params.require(:question).permit(:title, :anonymous).with_defaults(user_id: current_user.id)
  end

  def update_question_params 
    # TODO control anonymous depending on a user
    params.require(:question).permit(:status, :rejection_cause)
  end
end
