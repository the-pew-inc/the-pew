class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
end
