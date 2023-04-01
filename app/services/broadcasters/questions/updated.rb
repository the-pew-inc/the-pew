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