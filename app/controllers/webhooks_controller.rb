class WebhooksController < ApplicationController

  def apple
    logger.info "Apple Sign In Notification [params]: #{params.inspect}"
    logger.info "Apple Sign In Notification [request]: #{request.raw_post}"
  end
end