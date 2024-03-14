# == Schema Information
#
# Table name: connections
#
#  id                 :uuid             not null, primary key
#  errors             :jsonb
#  force_invalidation :boolean
#  last_refreshed_at  :datetime
#  oauth_token        :string
#  refresh_token      :string
#  settings           :jsonb
#  status             :integer
#  throttle           :integer          default(10), not null
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
