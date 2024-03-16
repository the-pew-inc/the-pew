module ConnectorsHelper
  def generate_oauth_url(connector, organization_id, user_id)
    case connector.name.downcase
    when 'hubspot'
      client_id = ENV.fetch('HUBSPOT_CLIENT_ID', nil)
      redirect_uri = webhooks_connectors_hubspot_index_url(protocol: request.ssl? ? 'https' : 'http')
      redirect_uri = CGI.escape(redirect_uri)
      scope = CGI.escape('crm.lists.read crm.objects.contacts.read crm.objects.marketing_events.read crm.schemas.custom.read crm.objects.custom.read crm.schemas.contacts.read crm.objects.feedback_submissions.read crm.objects.companies.read crm.objects.deals.read crm.schemas.companies.read crm.schemas.deals.read crm.objects.quotes.read crm.schemas.quotes.read crm.schemas.line_items.read crm.objects.goals.read conversations.read ctas.read tickets')

      # Construct state payload
      state_payload = { organization_id:, user_id:, connector_id: connector.id }.to_json
      encoded_signed_state = PayloadHandler.sign_payload(state_payload)

      "https://app.hubspot.com/oauth-bridge?client_id=#{client_id}&redirect_uri=#{redirect_uri}&scope=#{scope}&state=#{encoded_signed_state}"
    when 'slack', 'zoom'
      connector.website
    else
      raise(ArgumentError, "Unsupported connector: #{connector.name}")
    end
  end
end
