# == Schema Information
#
# Table name: question_answers
#
#  id          :uuid             not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :uuid             not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_question_answers_on_question_id  (question_id)
#  index_question_answers_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#  fk_rails_...  (user_id => users.id)
#
class QuestionAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  has_rich_text :text_answer

  has_many_attached :document_answers
end
