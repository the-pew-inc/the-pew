# frozen_string_literal: true

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
class Group < ApplicationRecord
  include PgSearch::Model

  # enable rolify on the Event class
  resourcify

  has_many :group_memberships
  has_many :users, through: :group_memberships
  has_many :resource_invites

  # Defines if the group only be accessed by the user who created it or if it
  # can be access by anyone from the organization
  enum group_type: { restricted: 0, organization: 10 }, _default: 0

  # PG_SEARCH
  pg_search_scope :search, against: [:name]
end
