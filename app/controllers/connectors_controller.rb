class ConnectorsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated
  # before_action :authorize_connector_access, only: %i[index show create]

  def index; end
end
