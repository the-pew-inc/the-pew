# == Schema Information
#
# Table name: profiles
#
#  id         :uuid             not null, primary key
#  mode       :integer          default("light"), not null
#  nickname   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_profiles_on_mode     (mode)
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Profile < ApplicationRecord
  include PgSearch::Model


  belongs_to :user

  # Tracking changes
  has_paper_trail

  # PG_SEARCH
  pg_search_scope :search,
    against: [:nickname],
    using: {
      tsearch: {
        prefix: true,
        dictionary: 'simple'
      }
    }

  # Active Storage & Action Text
  has_rich_text    :bio
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize: "100x100"
    attachable.variant :medium, resize: "144x144"
    attachable.variant :large, resize: "400x400"
  end

  validates :nickname, presence: true, length: { minimum: 3, maximum: 40 }
  validates :avatar, content_type: ['image/png', 'image/jpeg', 'image/jpg', 'image/gif'],
                     size: { between: 1.kilobyte..3.megabytes, message: 'is not given between size' }

  enum mode: { light: 0, dark: 1 }
end
