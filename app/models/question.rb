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

end
