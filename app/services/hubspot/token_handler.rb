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

    # Revokes the HubSpot refresh token associated with a connection.
    #
    # This method sends a request to HubSpot's API to revoke the refresh token.
    # On success, it logs a message and returns true. In case of an error,
    # it logs the error details including the error message, context, and
    # correlation ID, then returns false.
    #
    # @param connection [Connection] The connection object containing the refresh token to be revoked.
    # @return [Boolean] true if the token is successfully revoked, false otherwise.
    def revoke_token(connection)
      opts = {
        token: connection.refresh_token,
        client_id: ENV.fetch('HUBSPOT_CLIENT_ID', nil),
        client_secret: ENV.fetch('HUBSPOT_CLIENT_SECRET', nil)
      }
      api_response = client.oauth.refresh_tokens_api.archive(opts)

      if api_response.status_code == 204
        Rails.logger.info('Token successfully revoked')
        true
      else
        Rails.logger.error("Unexpected response status code: #{api_response.status_code}")
        false
      end
    rescue Hubspot::OAuth::ApiError => e
      error_details = JSON.parse(e.response_body)

      error_message = error_details['message']
      error_context = error_details['context']&.map { |k, v| "#{k}: #{v.join(', ')}" }&.join(', ')
      error_correlation_id = error_details['correlationId']

      Rails.logger.error("Failed to revoke token: #{error_message}, Context: #{error_context}, Correlation ID: #{error_correlation_id}")
      false
    end
  end
end
