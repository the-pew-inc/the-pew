# == Schema Information
#
# Table name: rooms
#
#  id              :uuid             not null, primary key
#  allow_anonymous :boolean          default(FALSE), not null
#  always_on       :boolean          default(FALSE), not null
#  name            :string           not null
#  start_date      :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  event_id        :uuid             not null
#  organization_id :uuid             not null
#
# Indexes
#
#  index_rooms_on_allow_anonymous  (allow_anonymous)
#  index_rooms_on_always_on        (always_on)
#  index_rooms_on_event_id         (event_id)
#  index_rooms_on_organization_id  (organization_id)
#  index_rooms_on_start_date       (start_date)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
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
  
  has_one    :embedded,    as: :embeddable, dependent: :destroy

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
