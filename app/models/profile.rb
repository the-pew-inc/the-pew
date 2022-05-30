class Profile < ApplicationRecord
  belongs_to :user

  # Active Storage & Action Text
  has_rich_text    :bio
  has_one_attached :avatar

  validates :nickname, presence: true, length: { minimum: 3, maximum: 40 }
  validates :avatar, content_type: ['image/png', 'image/jpeg', 'image/jpg', 'image/gif'], 
                    size: { between: 1.kilobyte..5.megabytes , message: 'is not given between size' }
end
