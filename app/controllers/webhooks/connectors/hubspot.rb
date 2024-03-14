class Webhooks::Connectors::Hubspot < ApplicationController
  skip_before_action :verify_authenticity_token
end
