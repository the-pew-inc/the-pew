class Account < ApplicationRecord
  belongs_to :user, optional: true

  has_one_attached :logo

  validates :website, url: { allow_nil: true, schemes: ['https'] }
  validates :name,   presence: true, length: { minimum: 3, maximum: 120 }
  validates :logo,   content_type: ['image/png', 'image/jpeg', 'image/jpg', 'image/gif'],
                     size: { between: 1.kilobyte..5.megabytes, message: 'is not given between size' }
end
