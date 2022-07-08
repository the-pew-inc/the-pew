class Question < ApplicationRecord
  # Enable rolify on the Question class
  resourcify

  # Add orderable_by_timestamp
  include OrderableByTimestamp

  # Tracking changes
  has_paper_trail

  belongs_to :user
  belongs_to :room
  has_many   :votes, as: :votable

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

  # Set of triggers to broadcast CRUD to the display
  after_create_commit do
    broadcast_prepend_later_to [self.room_id, :questions], target: "questions", partial: "questions/question_frame", locals: { question: self } if Current.user
  end

  after_update_commit do
    broadcast_update_later_to [self.room_id, :questions], partial: "questions/question_frame", locals: { question: self }
  end

  after_destroy_commit do
    broadcast_remove_to [self.room_id, :questions]
  end

end
