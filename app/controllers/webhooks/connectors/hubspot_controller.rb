# frozen_string_literal: true

class Webhooks::Connectors::HubspotController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    # Handle OAuth error from Hubspot
    if params[:error].present?
      # Log the error and redirect with an error message
      Rails.logger.error("Error during HubSpot OAuth callback: #{params[:error]} - #{params[:error_description]}")
      redirect_to(connectors_path, alert: "OAuth error: #{params[:error_description]}")
      return
    end

    # Decode and verify the signed state parameter to extract organization_id, user_id, and connector_id
    state_data = PayloadHandler.decode_signed_payload(params[:state])

    # Check if the state_data is present after decoding and verification
    unless state_data
      redirect_to(connectors_path, alert: 'Invalid or tampered state parameter.')
      return
    end

    organization_id = state_data['organization_id']
    connector_id = state_data['connector_id']
    user_id = state_data['user_id']

    # The Autorization token returned by Hubspot
    autorization_token = params[:code]

    # Save or update the connection
    connection = Connection.find_or_initialize_by(organization_id:, user_id:, connector_id:)

    # Get the access and refresh tokens from HubSpot API and store it
    api_client = Hubspot::Client.new(api_key: ENV.fetch('HUBSPOT_CLIENT_ID', nil))

    api_response = api_client.oauth.tokens_api.create(
      grant_type: 'authorization_code',
      code: autorization_token,
      redirect_uri: webhooks_connectors_hubspot_index_url(protocol: request.ssl? ? 'https' : 'http'),
      client_id: ENV.fetch('HUBSPOT_CLIENT_ID', nil),
      client_secret: ENV.fetch('HUBSPOT_CLIENT_SECRET', nil)
    )
    connection.access_token = api_response.access_token
    connection.refresh_token = api_response.refresh_token

    # Set last refresh time
    connection.last_refreshed_at = Time.current

    if connection.save
      # Set the status to active
      connection.active!
      # Handle successful save, e.g., redirect or render a success response
      redirect_to(connectors_path, notice: 'Connection successfully established.')
    else
      # Handle save error, e.g., render an error response
      connection.error!
      connection.error_msg = {
        msg: connection.errors.full_messages.to_sentence
      }
      connection.save
      redirect_to(connectors_path, alert: "Failed to establish connection: #{connection.errors.full_messages.to_sentence}.")
    end
  rescue JSON::ParserError => e
    # Log the error details
    Rails.logger.error("JSON::ParserError encountered in Webhooks::Connectors::Hubspot#create: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    redirect_to(connectors_path, alert: 'Invalid state parameter.')
  end
end
