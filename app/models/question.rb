class Question < ApplicationRecord
  # Enable rolify on the Question class
  resourcify

  # Add orderable_by_timestamp
  include OrderableByTimestamp

  # Tracking changes
  has_paper_trail

  belongs_to :user
  belongs_to :room
  has_many   :votes, as: :votable, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3, maximum: 250 }

  enum status: {
    asked: 0,
    approved: 10,
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

  scope :questions_for_room, -> (room) { where('room_id = ?', room) }
  scope :approved_questions_for_room, -> (room) { where('room_id = ?', room).approved }

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

  # Set of triggers to broadcast CRUD to the display
  after_create_commit do
    broadcast_update_later_to [self.room_id, :questions], target: Question.approved_questions_for_room(self.room_id).count if self.approved?
    broadcast_prepend_later_to [self.room_id, :questions], target: "questions", partial: "questions/question_frame", locals: { question: self } if Current.user
  end

  after_update_commit do
    broadcast_update_later_to [self.room_id, :questions], target: "question_counter", html: Question.approved_questions_for_room(self.room_id).count if self.approved?
    broadcast_update_later_to [self.room_id, :questions], partial: "questions/question_frame", locals: { question: self }
  end

  after_destroy_commit do
    broadcast_remove_to [self.room_id, :questions]
  end

end
