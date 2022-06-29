class Room < ApplicationRecord
  # enable rolify on the Room class
  resourcify

  belongs_to :event
  has_many   :questions, dependent: :destroy

  validates :name, presence: true
end
