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

  # Export question to CSV
  require 'csv'
  def self.to_csv(room_id)
    attributes = %w{title email name created_at updated_at status rejection_cause}

    questions = where(room_id: room_id).order(created_at: :desc)
    CSV.generate(headers: true) do |csv|
      csv << attributes
      questions.each do |question|
        csv << attributes.map{ |attr| question.send(attr) }
      end
    end
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
    broadcast_prepend_later_to [self.room_id, :questions], target: "questions", partial: "questions/question_frame", locals: { question: self } if Current.user
    broadcast_update_later_to  [self.room_id, :questions], target: "question_counter", html: Question.approved_questions_for_room(self.room_id).count if self.approved?
  end

  after_update_commit do
    broadcast_update_later_to [self.room_id, :questions], target: self, partial: "questions/question_frame", locals: { question: self }
    broadcast_update_later_to [self.room_id, :questions], target: "question_counter", html: Question.approved_questions_for_room(self.room_id).count if self.approved?
  end

  after_destroy_commit do
    broadcast_update_to [self.room_id, :questions], target: "question_counter", html: Question.approved_questions_for_room(self.room_id).count
    broadcast_remove_to [self.room_id, :questions], target: self
  end

end
