class Event < ApplicationRecord
  before_save :set_duration

  has_many :rooms, dependent: :destroy

  validates :name, presence: true, length: { minimum: 5, maximum: 250 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_is_after_start_date

  enum status: { draft: 0, published: 10, opened: 20, closed: 30, archived: 40 }

  # Universal: everyone can see questions, asking question requires an account
  # Restricted: seeing and asking questions require an account
  # Invite_only: seeing and asking questions require an account and an invitation
  enum event_type: { universal: 10, restricted: 20 , invite_only: 30 }, _default: 10

  private
  
  def set_duration
    self.duration = (self.stop_date - self.start_date).to_i
  end

  def end_date_is_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "cannot be before the start date") 
    end
  end
  
end
