class ConnectorsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated
  # before_action :authorize_connector_access, only: %i[index show create]

  def index
    @connectors = Connector.where(enabled: true).order(:name)

    organization_connections = current_user.organization.connections.active
    # @installed_connector_ids = @organization_connections ? @organization_connections.map(&:connector_id).uniq : []
    # Create a mapping of connector_id to Connection objects for easy retrieval
    @connector_to_connection = organization_connections.index_by(&:connector_id)
  end
end
