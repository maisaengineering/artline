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
    @project = Project.create(project_params)
    if @project.save
      flash[:notice] = "Successfully created."
      redirect_to edit_projects_path
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

  private

  def project_params
    params.require(:project).permit(params[:project].keys)
  end

end
