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

  # Self-reference
  # Used to nest questions
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

  scope :questions_for_room, -> (room) { where('room_id = ? AND parent_id IS NULL', room) }
  scope :approved_questions_for_room, -> (room) { where('room_id = ?', room).approved.or(where('room_id = ?', room).answered) }
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

  after_create_commit do
    broadcast_prepend_later_to self.room_id, target: "questions", partial: "questions/question_frame", locals: { question: self } if Current.user
    broadcast_update_later_to  self.room_id, target: "question_counter", html: Question.approved_questions_for_room(self.room_id).count if (self.approved? || self.answered?)
    broadcast_update_later_to  self.room_id, target: "asked_question_counter", html: Question.asked_questions_for_room(self.room_id).count
  end

  after_update_commit do
    broadcast_update_later_to self.room_id, target: self, partial: "questions/question_frame", locals: { question: self }
    broadcast_update_later_to "display_#{self.room_id}", target: "question", partial: "rooms/question", locals: { question: self } if self.beinganswered?
    broadcast_update_later_to self.room_id, target: "question_counter", html: Question.approved_questions_for_room(self.room_id).count if (self.approved? || self.answered?)
    broadcast_update_later_to self.room_id, target: "asked_question_counter", html: Question.asked_questions_for_room(self.room_id).count
  end

  after_destroy_commit do
    broadcast_update_to self.room_id, target: "asked_question_counter", html: Question.asked_questions_for_room(self.room_id).count
    broadcast_update_to self.room_id, target: "question_counter", html: Question.approved_questions_for_room(self.room_id).count
    broadcast_remove_to self.room_id, target: self
  end

end
