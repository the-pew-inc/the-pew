class Room < ApplicationRecord
  # enable rolify on the Room class
  resourcify

  belongs_to :event

  validates :name, presence: true
end
