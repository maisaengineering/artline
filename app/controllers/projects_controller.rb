class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: ["customer_qoute"]
  before_action :set_project, only:  [:show, :destroy, :customer_qoute, :send_quotation, :update, :rfq]
  # load_and_authorize_resource
  def index
   @projects = Project.desc(:created_at).paginate(page: params[:page], per_page: 5)
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.new(project_params.merge(company:company_params))
    if @project.save
      flash[:notice] = "Successfully created."
      redirect_to projects_path
    else
      render :new
    end
  end

  def show
    if @project.blank?
      render nothing: true, status:404
    else
      @rfqs = @project.rfqs
      @items = @project.items.group_by{|item| !item["number"].blank? || !@rfqs.in(item_ids_quoted: [item.id.to_s]).blank? }
    end
  end

  def edit

  end

  def update
    @project.update(project_params)
    flash[:notice] = "Successfully Updated"  unless @project.errors.any?
    redirect_to :back

  end

  def destroy
     if @project.destroy
       flash[:notice] = "Project successfully deleted"
       redirect_to projects_url
     end
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

  def rfq
    params[:rsq_data].each do |supplier_id, item_ids|
      rfq_var=@project.rfqs.find_or_initialize_by(supplier_id: supplier_id)
      rfq_var.item_ids_to_quote = (rfq_var.item_ids_to_quote.to_a + item_ids).uniq
      rfq_var.save
    end

    respond_to do |format|
      format.html
      format.json {render json: {redirect_url: projects_path} }
    end
  end

  def customer_qoute
    if @project.blank?
      render nothing: true, status:404
    else
      @rfqs = @project.rfqs
      @items = @project.items.group_by{|item| !item["number"].blank? || !@rfqs.in(item_ids_quoted: [item.id.to_s]).blank? }
      i=0
      @product = @items[true].map do |item|
        client_price = Price.find_by(artline_item_number: item["number"]).client_cost(item["additional_charge"].to_i)
        product_details = "#{item['type']} : \n #{item.product.details}"
        [i+=1, product_details, item["quantity"], client_price, client_price * item["quantity"].to_i ]
      end if @items[true]
      @product.push(["","","","Shipping Cost", 0])
      @product.push(["","","","Total", @product.map{|x| x.last}.inject(:+)])

    end
  end

  def send_quotation
    if @project.blank?
      render nothing: true, status:404
    else
      ClientMailer.quote(@project.id).deliver_now
      flash[:notice] = "Successfully Sent to Client"

      redirect_to project_path(@project)
    end
  end

  def search
    @projects = Project.where("$text"=>{"$search"=>params["key"]}).paginate(page: params[:page], per_page: 5)
    render 'index'
  end



  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit!
  end

  def company_params
    params.require(:company).permit(params[:company].keys+ [attention:[]])
  end

end
