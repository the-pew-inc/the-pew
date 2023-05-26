class EmbeddedsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  def create
    @embedded = current_user.embeddeds.new(embedded_params)
    @embedded.organization_id = current_user.organization.id
    
    if @embedded.save
      redirect_to [:edit, @embedded]
    else
      flash.now[:alert] = "An error occured preventing the Embedded Link to be generated"
    end
  end

  def destroy
    @embedded = Embedded.find(params[:id])
    @embedded.destroy
  end

  def edit
    @embedded = current_user.embeddeds.find(params[:id])
  end

  def index
    @embeddeds = current_user.embeddeds
  end

  def show
    headers["X-Frame-Options"] = "allowall"
    @embedded = Embedded.find_by(token: params[:id])
    render template: "#{@embedded.path}", layout: false
  end 

  def update
  end

  private

  def embedded_params
    params.require(:embedded).permit(:path, :label, :embeddable_id, :embeddable_type)
  end

end
