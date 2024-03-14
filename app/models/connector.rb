# frozen_string_literal: true

# == Schema Information
#
# Table name: connectors
#
#  id           :uuid             not null, primary key
#  author       :string
#  enabled      :boolean          default(FALSE), not null
#  github       :string
#  name         :string           not null
#  redirect_url :string           not null
#  settings     :jsonb            not null
#  tags         :string           default([]), is an Array
#  verified     :boolean          default(FALSE), not null
#  version      :string
#  website      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_connectors_on_enabled   (enabled)
#  index_connectors_on_name      (name) UNIQUE
#  index_connectors_on_tags      (tags) USING gin
#  index_connectors_on_verified  (verified)
#
class Connector < ApplicationRecord
  # enable rolify on the Event class
  resourcify

  # Tracking changes
  has_paper_trail

  # Logo
  has_one_attached :logo

  # Description
  has_rich_text :description

  # Screenshots
  has_many_attached :screenshots

  # Connections
  has_many :connections, dependent: :destroy

  # Validations
  validates :name,    presence: true
  validates :version, presence: { message: 'Missing on Invalid version' }, allow_blank: false

  # validates :description, presence: true
  # validates :logo,  content_type: ['image/png', 'image/jpeg', 'image/jpg', 'image/gif'],
  #                   size: { between: 1.kilobyte..5.megabytes, message: 'is not given between size' }
end
