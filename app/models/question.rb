class Question < ApplicationRecord
  # enable rolify on the Question class
  resourcify

  belongs_to :user
  belongs_to :room

  validates :title, presence: true, length: { minimum: 3, maximum: 250 }

  enum status: {
    asked: 0,
    approved: 10,
    answered: 20,
    rejected: 30
  }

  scope :questions_for_room, -> (room) { where('room_id = ?', room).order(:created_at) }

  # Set of triggers to broadcast CRUD to the display
  after_create_commit do
    broadcast_prepend_to [self.room.id, :questions], target: "rooms", partial: "room/question", locals: { question: self } if Current.user
  end

  after_update_commit do
    broadcast_update_to [self.room.id, :questions], partial: "room/question", locals: { question: self }
  end

  after_destroy_commit do
    broadcast_remove_to [self.room.id, :questions]
  end

end
