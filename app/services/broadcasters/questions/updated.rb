# Removing the broadcast_..._to from the model and placing them into their respective Service class
# There is one service class per action: Created, Updated and Deleted
# The service class can be called anywhere, including in the console, as soon as a
# proper question object is passed.
# Exanple: 
#
# @question = Question.first
# ... perform some updates on @question and save them before calling
# Broadcasters::Questions::Updated.new(@question).call
class Broadcasters::Questions::Updated
  attr_reader :question

  def initialize(question)
    @question = question
  end

  def call
    Turbo::StreamsChannel.broadcast_update_later_to @question.room_id, target: @question, partial: "questions/question_frame", locals: { question: @question }
    Turbo::StreamsChannel.broadcast_update_later_to "display_#{@question.room_id}", target: "question", partial: "rooms/question", locals: { question: @question } if @question.beinganswered?
    Turbo::StreamsChannel.broadcast_update_later_to @question.room_id, target: "question_counter", html: Question.approved_questions_for_room(@question.room_id).count if (@question.approved? || @question.beinganswered? || @question.answered?)
    Turbo::StreamsChannel.broadcast_update_later_to @question.room_id, target: "asked_question_counter", html: Question.asked_questions_for_room(@question.room_id).count
  end

end