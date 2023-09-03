# == Schema Information
#
# Table name: questions
#
#  id              :uuid             not null, primary key
#  ai_response     :jsonb
#  anonymous       :boolean          default(FALSE), not null
#  keywords        :string           default([]), is an Array
#  rejection_cause :integer
#  status          :integer          default("asked"), not null
#  title           :string           not null
#  tone            :integer          default("undefined"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#  parent_id       :uuid
#  room_id         :uuid             not null
#  user_id         :uuid             not null
#
# Indexes
#
#  index_questions_on_anonymous            (anonymous)
#  index_questions_on_organization_id      (organization_id)
#  index_questions_on_parent_id            (parent_id)
#  index_questions_on_rejection_cause      (rejection_cause)
#  index_questions_on_room_id              (room_id)
#  index_questions_on_status               (status)
#  index_questions_on_tone                 (tone)
#  index_questions_on_user_id              (user_id)
#  index_questions_on_user_id_and_room_id  (user_id,room_id)
#  index_questions_on_user_id_and_status   (user_id,status)
#
# Foreign Keys
#
#  fk_rails_...  (room_id => rooms.id)
#  fk_rails_...  (user_id => users.id)
#
class Question < ApplicationRecord
  # Enable rolify on the Question class
  resourcify

  # Add orderable_by_timestamp
  include OrderableByTimestamp

  # Tracking changes
  has_paper_trail

  # Set the account_id (value is taken from the event)
  before_validation :set_organization_id

  belongs_to :user
  belongs_to :room
  has_many   :votes, as: :votable, dependent: :destroy

  has_one :answer, class_name: "QuestionAnswer", dependent: :destroy

  # Self-reference
  # Used to nest questions // To be implemented
  belongs_to :parent, optional: true, class_name: "Question"
  has_many   :questions, foreign_key: :parent_id, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3, maximum: 250 }

  enum status: {
    asked: 0,
    approved: 10,
    beinganswered: 15,
    answered: 20,
    rejected: 30
  }, _default: :asked

  enum rejection_cause: {
    inapropriate: 10,
    offensive: 20,
    duplicate: 30,
    explicit: 40,
    other: 50
  }

  enum tone: {
    positive: 30,
    neutral: 20,
    negative: 10,
    undefined: 0
  }

  scope :questions_for_room, -> (room) { where('room_id = ? AND parent_id IS NULL', room) }
  scope :approved_questions_for_room, -> (room) { where('room_id = ?', room).approved.or(where('room_id = ?', room).answered).or(where('room_id = ?', room).beinganswered) }
  scope :asked_questions_for_room, -> (room) { where('room_id = ?', room).asked }

  # This is the sum of +1 and -1
  def vote_count
    Vote.where(votable_id: self.id).sum(:choice)
  end

  # This only sums the +1
  def up_votes
    Vote.where(votable_id: self.id).up_vote.sum(:choice)
  end

  # This only sums the -1
  def down_votes
    Vote.where(votable_id: self.id).down_vote.sum(:choice)
  end

  def name
    if anonymous
      "User wished to remain anonymous"
    else
      "#{self.user.profile.nickname}"
    end
  end

  def email
    if anonymous
      "User does not want to share their email"
    else
      "#{self.user.email}"
    end
  end

  private

  def set_organization_id
    self.organization_id = self.room.organization_id if self.organization_id.nil?
  end

end
