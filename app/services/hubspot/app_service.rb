# frozen_string_literal: true

# app/services/hubspot/api_service.rb

module Hubspot
  class AppService
    # def self.client
    #   @client ||= Hubspot::Client.new(api_key: ENV.fetch('HUBSPOT_CLIENT_ID', nil))
    # end

    def self.retrieve_main
      # Retrieve HubSpot connections that require a pull
      hubspot_connector = Connector.find_by(name: 'Hubspot')
      hubspot_connections = hubspot_connector.connections.where('(force_pull = true OR last_pull_at IS NULL) AND is_being_pulled = false')

      hubspot_connections.each do |connection|
        # Starting the pull process for this customer
        connection.update!(is_being_pulled: true, pull_start_at: Time.current)

        # Retrieving the HubSpot lists
        lists = retrieve_lists(connection)
        Rails.logger.debug { "List Retrieved from Hubspot: #{lists}" }

        # Retrieving the HubSpot companies
        retrieve_companies(connection)

        # Closing the pull process for this customer
        connection.update!(is_being_pulled: false, force_pull: false, last_pull_at: Time.current)
      end
    end

    def self.retrieve_lists(connection, attempt_refresh: true)
      client = Hubspot::Client.new(access_token: connection.access_token)
      client.crm.lists.lists_api.get_all
    rescue Hubspot::Crm::Lists::ApiError => e
      error_response = JSON.parse(e.response_body)

      # Check if the error is due to an expired token and if a refresh attempt should be made
      if error_response['category'] == 'EXPIRED_AUTHENTICATION' && attempt_refresh
        Rails.logger.debug('Access token expired, attempting to refresh')

        Hubspot::TokenHandler.refresh_access_token(connection)
        return retrieve_lists(connection, attempt_refresh: false)
      end

      # Log the general error if not handled above
      Rails.logger.error("Error retrieving HubSpot lists: #{e.response_body}")
      []
    end

    def self.retrieve_companies(connection, attempt_refresh: true)
      client = Hubspot::Client.new(access_token: connection.access_token)
      client.crm.companies.basic_api.get_all
    rescue Hubspot::Crm::Companies::ApiError => e
      error_response = JSON.parse(e.response_body)

      # Check if the error is due to an expired token and if a refresh attempt should be made
      if error_response['category'] == 'EXPIRED_AUTHENTICATION' && attempt_refresh
        Rails.logger.info('Access token expired, attempting to refresh')

        Hubspot::TokenHandler.refresh_access_token(connection)
        return retrieve_companies(connection, attempt_refresh: false)
      end
      Rails.logger.error("Error retrieving HubSpot companies: #{e.response_body}")
      []
    end
  end
end
