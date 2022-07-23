class Room < ApplicationRecord
  # enable rolify on the Room class
  resourcify

  # Tracking changes
  has_paper_trail

  belongs_to :event
  has_many   :questions, dependent: :destroy

  validates  :name, presence: true

  # Return the number of approved questions in this room
  def approved_question_count
    self.questions.approved.count
  end

end
