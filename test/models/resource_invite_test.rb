# == Schema Information
#
# Table name: resource_invites
#
#  id              :uuid             not null, primary key
#  email           :string
#  error_msg       :text
#  expires_at      :datetime
#  invitable_type  :string           not null
#  sent_on         :datetime
#  status          :integer
#  template        :string
#  token           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  group_id        :uuid
#  invitable_id    :uuid             not null
#  organization_id :uuid             not null
#  recipient_id    :uuid
#  sender_id       :uuid             not null
#
# Indexes
#
#  index_resource_invites_on_email            (email)
#  index_resource_invites_on_group_id         (group_id)
#  index_resource_invites_on_invitable        (invitable_type,invitable_id)
#  index_resource_invites_on_organization_id  (organization_id)
#  index_resource_invites_on_recipient_id     (recipient_id)
#  index_resource_invites_on_sender_id        (sender_id)
#  index_resource_invites_on_status           (status)
#  index_resource_invites_on_token            (token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
require "test_helper"

class ResourceInviteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
