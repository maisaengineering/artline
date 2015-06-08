class ProjectsController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource
  def new

  end
  def create

  end
  def edit

  end

  def update
  end
  def destroy

  end
  def index

  end

  private

  def project_params
    params.require(:project).permit(params[:project].keys)
  end
end
