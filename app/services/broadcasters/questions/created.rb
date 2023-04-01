# Removing the broadcast_..._to from the model and placing them into their respective Service class
# There is one service class per action: Created, Updated and Deleted
# The service class can be called anywhere, including in the console, as soon as a
# proper question object is passed.
# Exanple: 
#
# @question = Question.first
# Broadcasters::Questions::Created.new(@question).call
class Broadcasters::Questions::Created
  attr_reader :question

  def initialize(question)
    @question = question
  end

  def call
    Turbo::StreamsChannel.broadcast_prepend_later_to @question.room_id, target: "questions", partial: "questions/question_frame", locals: { question: @question } if Current.user
    Turbo::StreamsChannel.broadcast_update_later_to  @question.room_id, target: "question_counter", html: Question.approved_questions_for_room(@question.room_id).count if (@question.approved? || @question.answered?)
    Turbo::StreamsChannel.broadcast_update_later_to  @question.room_id, target: "asked_question_counter", html: Question.asked_questions_for_room(@question.room_id).count
  end

end