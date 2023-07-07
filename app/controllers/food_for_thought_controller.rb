class FoodForThoughtController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

  def show
    @article = FoodForThought.find(params[:id])
    # with_rich_text_content_and_embeds
  end
end
