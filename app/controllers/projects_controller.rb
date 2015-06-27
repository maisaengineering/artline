class ProjectsController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource
  def index
   # render text:"123"
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params.merge(company:company_params))
    if @project.save
      flash[:notice] = "Successfully created."
      redirect_to projects_path
    else
      render :new
    end
  end

  def show

  end

  def edit

  end

  def update
  end
  def destroy

  end

  def product_ajax_load

  end

  private

  def project_params


    params.require(:project).permit!
  end

  def company_params
    params.require(:company).permit(params[:company].keys+ [attention:[]])
  end

end
