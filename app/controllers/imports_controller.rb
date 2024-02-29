class ImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_unauthenticated

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
end
