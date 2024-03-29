# frozen_string_literal: true

# == Schema Information
#
# Table name: rooms
#
#  id              :uuid             not null, primary key
#  allow_anonymous :boolean          default(FALSE), not null
#  always_on       :boolean          default(FALSE), not null
#  end_date        :datetime         not null
#  name            :string           not null
#  room_type       :integer          default("universal"), not null
#  start_date      :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  event_id        :uuid             not null
#  organization_id :uuid
#
# Indexes
#
#  index_rooms_on_allow_anonymous  (allow_anonymous)
#  index_rooms_on_always_on        (always_on)
#  index_rooms_on_event_id         (event_id)
#  index_rooms_on_organization_id  (organization_id)
#  index_rooms_on_room_type        (room_type)
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
  before_validation :set_end_date # Set the end date in case the user is not passing one

  belongs_to :event
  has_many   :attendances, dependent: :destroy
  has_many   :questions,   dependent: :destroy

  # Link to resource invitation(s)
  has_many :resource_invites, as: :invitable, dependent: :destroy

  has_rich_text :description
  has_rich_text :public_description

  validates :name, presence: true

  # Universal: everyone can see questions, asking question requires an account
  # Restricted: seeing and asking questions require an account
  # Invite_only: seeing and asking questions require an account and an invitation
  enum room_type: { universal: 10, restricted: 20, invite_only: 30 }, _default: 10

  # Return the number of approved, being answered or answered questions in this room
  def approved_question_count
    questions.where(status: :approved).or(questions.where(status: :beinganswered)).or(questions.where(status: :answered)).count
  end

  # Return the number of questions with the status "asked" in this room
  def asked_question_count
    questions.where(status: :asked).count
  end

  private

  def set_organization_id
    self.organization_id = event.organization_id if organization_id.nil?
  end

  # Used in case the user is not passing an end_date
  def set_end_date
    self.end_date = start_date if end_date.nil?
  end
end
