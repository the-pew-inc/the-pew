# == Schema Information
#
# Table name: members
#
#  id              :uuid             not null, primary key
#  owner           :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#  user_id         :uuid             not null
#
# Indexes
#
#  index_members_on_organization_id  (organization_id)
#  index_members_on_owner            (owner)
#  index_members_on_user_id          (user_id)
#
require "test_helper"

class MemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
