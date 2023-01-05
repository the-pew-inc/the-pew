class Room < ApplicationRecord
  # enable rolify on the Room class
  resourcify

  # Tracking changes
  has_paper_trail

  belongs_to :event
  has_many   :attendances, dependent: :destroy
  has_many   :questions,   dependent: :destroy

  validates  :name, presence: true

  # Return the number of approved questions in this room
  def approved_question_count
    self.questions.where(status: :approved).or(self.questions.where(status: :beinganswered)).count
  end

  # Return the number of questions with the status "asked" in this room
  def asked_question_count
    self.questions.where(status: :asked).count
  end

end
