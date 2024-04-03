# frozen_string_literal: true

module ConnectorsHelper
  def generate_oauth_url(connector, organization_id, user_id)
    case connector.name.downcase
    when 'hubspot'
      hubspot_oauth_url(connector, organization_id, user_id)
    when 'slack', 'zoom'
      connector.website
    else
      raise(ArgumentError, "Unsupported connector: #{connector.name}")
    end
  end

  private

  def hubspot_oauth_url(connector, organization_id, user_id)
    client_id = ENV.fetch('HUBSPOT_CLIENT_ID', nil)

    # Join the scopes array into a space-separated string as expected by HubSpot
    scope = connector.scope.join('%20')

    # Handle optional_scopes: join into a space-separated string if present and not empty
    optional_scope = connector.optional_scope&.any? ? connector.optional_scope.join('%20') : nil

    # Construct state payload
    state_payload = { organization_id:, user_id:, connector_id: connector.id }.to_json
    encoded_signed_state = PayloadHandler.sign_payload(state_payload)

    # Construct the OAuth URL, conditionally adding optional_scope if it exists
    oauth_url = "https://app.hubspot.com/oauth/authorize?client_id=#{client_id}&redirect_uri=#{hubspot_redirect_uri}&scope=#{scope}"
    oauth_url += "&optional_scope=#{optional_scope}" if optional_scope
    oauth_url += "&state=#{encoded_signed_state}"

    oauth_url
  end

  def hubspot_redirect_uri
    webhooks_connectors_hubspot_index_url(protocol: request.ssl? ? 'https' : 'http')
  end
end
