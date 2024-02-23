# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  id         :uuid             not null, primary key
#  owner      :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_members_on_account_id  (account_id)
#  index_members_on_owner       (owner)
#  index_members_on_user_id     (user_id)
#
class Member < ApplicationRecord
  # Tracking changes
  has_paper_trail

  belongs_to :user
  belongs_to :organization
end
