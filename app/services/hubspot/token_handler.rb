# frozen_string_literal: true

# app/services/hubspot/token_handler.rb

# The Hubspot::TokenHandler module provides a set of utility functions for managing OAuth tokens
# in the context of the HubSpot API. This includes revoking tokens, refreshing access tokens,
# and retrieving stored refresh tokens from your application's storage mechanism (e.g., database).

module Hubspot
  module TokenHandler
    module_function

    def self.client
      @client ||= Hubspot::Client.new(api_key: ENV.fetch('HUBSPOT_CLIENT_ID', nil))
    end

    # Method used to refresh the access token in the Connection object
    # using the associated refresh token.
    def refresh_access_token(connection)
      # Prepare the request parameters
      opts = {
        grant_type: 'refresh_token',
        client_id: ENV.fetch('HUBSPOT_CLIENT_ID', nil),
        client_secret: ENV.fetch('HUBSPOT_CLIENT_SECRET', nil),
        refresh_token: connection.refresh_token
      }

      begin
        # Request a new access token using the refresh token
        response = client.oauth.tokens_api.create(opts)
        Rails.logger.info("Successfully refreshed access token: #{response}")
        connection.update!(
          access_token: response.access_token,
          refresh_token: response.refresh_token,
          last_refreshed_at: Time.current,
          token_expires_at: Time.current + response.expires_in.seconds,
          updated_at: Time.current
        )
      rescue Hubspot::OAuth::ApiError => e
        Rails.logger.error("Failed to refresh access token: #{e.response_body}")
        connection.update!(error_msg: { oauth: { error: e.response_body, error_at: Time.current } })
      end
    end

    # Used when the app is removed from HubSpot
    # Revoking the access token will remove the app from the HubSpot account
    def revoke_token(token)
    end
  end
end
