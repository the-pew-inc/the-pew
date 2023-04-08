# There is one service class per action: Created, Updated and Deleted
# The service class can be called anywhere, including in the console, as soon as a
# proper question object is passed.
# Exanple: 
#
# @question = Question.first
# delete the question
# Broadcasters::Questions::Deleted.new(@question).call
class Broadcasters::Questions::Deleted
  attr_reader :question

  def initialize(question)
    @question = question
  end

  def call
    Turbo::StreamsChannel.broadcast_update_to @question.room_id, target: "asked_question_counter", html: Question.asked_questions_for_room(@question.room_id).count
    Turbo::StreamsChannel.broadcast_update_to @question.room_id, target: "question_counter", html: Question.approved_questions_for_room(@question.room_id).count
    Turbo::StreamsChannel.broadcast_remove_to @question.room_id, target: @question
  end

end