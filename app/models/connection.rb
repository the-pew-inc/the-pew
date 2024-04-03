# == Schema Information
#
# Table name: connections
#
#  id                 :uuid             not null, primary key
#  access_token       :string
#  error_msg          :jsonb
#  force_invalidation :boolean
#  force_pull         :boolean          default(FALSE), not null
#  granted_scope      :string           default([]), is an Array
#  is_being_pulled    :boolean          default(FALSE), not null
#  last_pull_at       :datetime
#  last_refreshed_at  :datetime
#  oauth_token        :string
#  pull_start_at      :datetime
#  refresh_token      :string
#  settings           :jsonb
#  status             :integer
#  throttle           :integer          default(10), not null
#  token_expires_at   :datetime
#  usage              :jsonb
#  usage_limits       :jsonb
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  connector_id       :uuid             not null
#  organization_id    :uuid             not null
#  user_id            :uuid             not null
#
# Indexes
#
#  index_connections_on_connector_id        (connector_id)
#  index_connections_on_force_invalidation  (force_invalidation)
#  index_connections_on_force_pull          (force_pull)
#  index_connections_on_is_being_pulled     (is_being_pulled)
#  index_connections_on_organization_id     (organization_id)
#  index_connections_on_status              (status)
#  index_connections_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Connection < ApplicationRecord
  # enable rolify on the Event class
  resourcify

  # Tracking changes
  has_paper_trail

  belongs_to :organization
  belongs_to :user
  belongs_to :connector

  enum status: { active: 10, error: 20, inactive: 30 }, _default: 30
end
