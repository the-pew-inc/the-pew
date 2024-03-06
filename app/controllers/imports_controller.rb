class ImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated
  before_action :authorize_import_access, only: %i[index show create]

  def index
    @import_results = current_user.import_results.order(created_at: :desc).limit(5)
    render(layout: 'settings')
  end

  def show
    @import_result = current_user.import_results.find(params[:id])
    render(layout: 'settings')
  end

  def new; end

  def create
    current_user.import_file.attach(params[:file])
    ProcessExcelImportJob.perform_async(current_user.id)
    redirect_to(imports_path, notice: 'File is being processed. Check back later for the results.')
  end

  private

  def authorize_import_access
    organization = current_user.organization
    return if ImportPolicy.new(current_user, organization).allowed?

    redirect_to(subscriptions_path, alert: 'You need an active subscription to access this feature.')
  end
end
