# frozen_string_literal: true

class ConnectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated
  before_action :set_organization
  before_action :set_connection, only: %i[edit update destroy show]

  # GET /connections/:id
  def show
    # The `set_connection` before_action sets @connection for us
  end

  # GET /connections/:id/edit
  def edit
    # The `set_connection` before_action sets @connection for us
  end

  # PATCH/PUT /connections/:id
  def update
    if @connection.update(connection_params)
      redirect_to(connectors_path, notice: 'Connector was successfully updated.')
    else
      render(:edit, alert: 'Failed to update connector.')
    end
  end

  # DELETE /connections/:id
  # Used to remove an existing connection
  def destroy
    if @connection.destroy
      redirect_to(connectors_path, notice: 'Connector was successfully removed.')
    else
      redirect_to(connectors_path, alert: 'Failed to remove connector.')
    end
  end

  private

  def set_organization
    @organization = current_user.organization
  end

  def set_connection
    @connection = @organization.connections.find(params[:id])
  end

  def connection_params
    params.require(:connection).permit(:connector_id, :status, :settings)
  end
end
