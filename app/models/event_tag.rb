class EventTag < ApplicationRecord
  before_save :clean_tag_name

  belongs_to :account
  belongs_to :user
  belongs_to :event
  belongs_to :room

  validates :name, presence: true, length: {maximum: 250}

  private

  # Remove trailing spaces and all carriage return / line feed that could be in the tag name
  def clean_tag_name
    self.name = self.name.strip.squish
  end
end
