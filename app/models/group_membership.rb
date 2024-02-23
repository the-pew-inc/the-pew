# frozen_string_literal: true

# == Schema Information
#
# Table name: group_memberships
#
#  id         :uuid             not null, primary key
#  role       :integer
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_group_memberships_on_group_id  (group_id)
#  index_group_memberships_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group
end
