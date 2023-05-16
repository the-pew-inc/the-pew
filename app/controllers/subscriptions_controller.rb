class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, only: %i[edit destroy update show]
  before_action :redirect_if_unauthenticated, except: %i[index new create]
  

  def index
    @plans = Plan.where(active: true)
  end

  def create

  end

  def new

  end

  def edit

  end

  def update

  end

end
