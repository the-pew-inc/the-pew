class Event < ApplicationRecord
  has_many :rooms, dependent: :destroy

  validates :name, presence: true, length: { minimum: 5, maximum: 250 }

  enum status: { draft: 0, published: 10, opened: 20, closed: 30, archived: 40 }
  enum event_type: { public: 10, private: 20 }, _default: 10

  # Assign unique numeric short_code to the event
  def assign_short_code
    self.short_code = SecureRandom.hex(6)
  end
  
end
