class Room < ApplicationRecord
  # enable rolify on the Room class
  resourcify

  # Tracking changes
  has_paper_trail

  # Set the account_id (value is taken from the event)
  before_validation :set_organization_id

  belongs_to :event
  has_many   :attendances, dependent: :destroy
  has_many   :questions,   dependent: :destroy

  validates  :name, presence: true

  # Return the number of approved, being answered or answered questions in this room
  def approved_question_count
    self.questions.where(status: :approved).or(self.questions.where(status: :beinganswered)).or(self.questions.where(status: :answered)).count
  end

  # Return the number of questions with the status "asked" in this room
  def asked_question_count
    self.questions.where(status: :asked).count
  end

  private

  def set_organization_id
    self.organization_id = self.event.organization_id if self.organization_id.nil?
  end
end
