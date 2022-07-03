class Room < ApplicationRecord
  # enable rolify on the Room class
  resourcify

  # Tracking changes
  has_paper_trail

  belongs_to :event
  has_many   :questions, dependent: :destroy

  validates :name, presence: true
end
