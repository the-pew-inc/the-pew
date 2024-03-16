# == Schema Information
#
# Table name: connections
#
#  id                 :uuid             not null, primary key
#  error_msg          :jsonb
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

  # Attempts to refresh the HubSpot access token using the stored refresh token.
  # This method should be called when the current access token is expired or about to expire.
  def refresh_access_token
    # Check if a refresh token exists before proceeding.
    return if refresh_token.blank?

    begin
      # Initialize the HubSpot OAuth client.
      oauth = Hubspot::Crm::Oauth.new

      # Request a new access token from HubSpot using the refresh token.
      token_response = oauth.create_token(
        grant_type: 'refresh_token',
        client_id: ENV.fetch('HUBSPOT_CLIENT_ID', nil),
        client_secret: ENV.fetch('HUBSPOT_CLIENT_SECRET', nil),
        refresh_token:
      )

      # Update the connection with the new access token and the current timestamp.
      update!(
        oauth_token: token_response.access_token,
        last_refreshed_at: Time.current
      )
    rescue StandardError => e
      # Log an error if the token refresh process fails.
      Rails.logger.error("Failed to refresh token: #{e.message}")
      # We might want to handle the refresh token failure more robustly here,
      # such as marking the connection as inactive or notifying an administrator.
    end
  end
end
