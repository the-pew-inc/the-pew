# == Schema Information
#
# Table name: embeddeds
#
#  id              :uuid             not null, primary key
#  embeddable_type :string           not null
#  label           :string
#  path            :string
#  token           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  embeddable_id   :uuid             not null
#  organization_id :uuid             not null
#  user_id         :uuid             not null
#
# Indexes
#
#  index_embeddeds_on_embeddable       (embeddable_type,embeddable_id)
#  index_embeddeds_on_organization_id  (organization_id)
#  index_embeddeds_on_path             (path) UNIQUE
#  index_embeddeds_on_token            (token) UNIQUE
#  index_embeddeds_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (user_id => users.id)
#
class Embedded < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  has_secure_token :token
end
