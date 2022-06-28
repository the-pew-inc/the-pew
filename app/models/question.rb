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
end
