class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :room

  validates :user, presence: true
  validates :event, presence: true
  validates :room, presence: true

  enum status: {
    offline: 0,
    online: 10,
    away: 20,
  }
end
