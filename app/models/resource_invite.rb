# == Schema Information
#
# Table name: resource_invites
#
#  id              :uuid             not null, primary key
#  email           :string           not null
#  expires_at      :datetime
#  invitable_type  :string           not null
#  status          :integer
#  template        :string
#  token           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  invitable_id    :uuid             not null
#  organization_id :uuid             not null
#  recipient_id    :uuid
#  sender_id       :uuid             not null
#
# Indexes
#
#  index_resource_invites_on_email                            (email)
#  index_resource_invites_on_invitable                        (invitable_type,invitable_id)
#  index_resource_invites_on_invitable_type_and_invitable_id  (invitable_type,invitable_id)
#  index_resource_invites_on_organization_id                  (organization_id)
#  index_resource_invites_on_recipient_id                     (recipient_id)
#  index_resource_invites_on_sender_id                        (sender_id)
#  index_resource_invites_on_status                           (status)
#  index_resource_invites_on_token                            (token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (recipient_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
class ResourceInvite < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User', optional: true
  belongs_to :invitable, polymorphic: true

  before_validation :generate_token, on: :create

  validates :token, presence: true, uniqueness: true
  validates :email, presence: true

  enum status: { pending: 0, accepted: 1, declined: 2, expired: 3 }

  def token_valid?
    self.expires_at > Time.now
  end

  private

  def generate_token
    self.token ||= SecureRandom.uuid
    self.expires_at ||= 24.hours.from_now
  end

end
