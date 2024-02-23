# == Schema Information
#
# Table name: groups
#
#  id              :uuid             not null, primary key
#  description     :text
#  group_type      :integer          default("restricted"), not null
#  icon            :string
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#  user_id         :uuid             not null
#
# Indexes
#
#  index_groups_on_group_type       (group_type)
#  index_groups_on_organization_id  (organization_id)
#  index_groups_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class GroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
