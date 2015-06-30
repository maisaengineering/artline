class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: ["customer_qoute"]
  # load_and_authorize_resource
  def index
   @projects = Project.desc(:created_at).paginate(page: params[:page], per_page: 5)
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
    @project = Project.find(params[:id])
    if @project.blank?
      render nothing: true, status:404
    else
      @items = @project.items.group_by{|item| !item["number"].blank?}
    end
  end

  def edit

  end

  def update
  end

  def destroy
  end

  def product_ajax_load
  end

  def request_supplier_qoute
    params[:rsq_data].each do |supplier_id, item_ids|
      current_user.request_quotes.create(item_ids: item_ids,supplier_id: supplier_id)
    end
    respond_to do |format|
      format.html
      format.json {render json: {redirect_url: projects_path} }
    end
  end

  def customer_qoute
    @project = Project.find(params[:id])
    if @project.blank?
      render nothing: true, status:404
    else
      @items = @project.items.group_by{|item| !item["number"].blank?}
    end
  end

  def send_quotation
    @project = Project.find(params[:id])
    if @project.blank?
      render nothing: true, status:404
    else
      ClientMailer.quote(@project.id).deliver_now
      render js:"alert('Successfully, Sent Quotation to client')"
    end
  end

  private

  def project_params
    params.require(:project).permit!
  end

  def company_params
    params.require(:company).permit(params[:company].keys+ [attention:[]])
  end

end
