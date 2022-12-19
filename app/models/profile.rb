class Profile < ApplicationRecord
  belongs_to :user

  # Tracking changes
  has_paper_trail

  # Active Storage & Action Text
  has_rich_text    :bio
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize: "100x100"
    attachable.variant :medium, resize: "144x144"
    attachable.variant :large, resize: "400x400"
  end

  validates :nickname, presence: true, length: { minimum: 3, maximum: 40 }
  validates :avatar, content_type: ['image/png', 'image/jpeg', 'image/jpg', 'image/gif'],
                     size: { between: 1.kilobyte..5.megabytes, message: 'is not given between size' }

  enum mode: { light: 0, dark: 1 }
end
