class EmbeddedsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  def create
    @embedded = current_user.embeddeds.create(embedded_params)
    redirect_to [:edit, @embedded]
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

  def new
    @embedded = Embedded.new
  end

  def show
    headers["X-Frame-Options"] = "allowall"
    @embedded = Embedded.find_by(token: params[:id])
    render template: "#{@embedded.controller}/#{@embedded.action}", layout: false
  end 

  def update
  end

  private

  def embedded_params
    params.require(:embedded).permit(:controller, :action)
  end

end
