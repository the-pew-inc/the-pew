# == Schema Information
#
# Table name: connectors
#
#  id          :uuid             not null, primary key
#  author      :string
#  description :text
#  github      :string
#  name        :string           not null
#  version     :string           not null
#  website     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Connector < ApplicationRecord
  # enable rolify on the Event class
  resourcify

  # Tracking changes
  has_paper_trail

  # Logo
  has_one_attached :logo

  # Screenshots
  has_many_attached :screenshots

  # Validations
  validates :name, presence: true
  # validates :description, presence: true
  validates :logo,  content_type: ['image/png', 'image/jpeg', 'image/jpg', 'image/gif'],
                    size: { between: 1.kilobyte..5.megabytes, message: 'is not given between size' }
end
