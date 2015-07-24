class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: ["customer_qoute"]
  before_action :set_project, only:  [:show, :destroy, :customer_qoute, :send_quotation, :update, :rfq, :create_order]
  # load_and_authorize_resource
  def index
    @projects = Project.where(:po_number.exists=>false).desc(:created_at).paginate(page: params[:page], per_page: 5)
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
      if @items[true].present?
        supplier_id =Price.in(artline_item_number: @items[true].map(&:number)).map(&:supplier_id).uniq
        @saved_rfqs = @project.rfqs.in(supplier_id: supplier_id)
      end
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
      rfqs = @project.rfqs.create(supplier_id: supplier_id,item_ids_to_quote: item_ids )
      # rfq_var=@project.rfqs.find_or_initialize_by(supplier_id: supplier_id)
      # rfq_var.item_ids_to_quote = (rfq_var.item_ids_to_quote.to_a + item_ids).uniq
      # rfq_var.save
    end

    respond_to do |format|
      format.html
      format.json {render json: {redirect_url: projects_path} }
    end
  end

  def create_order
    items = Hash[@project.items.in(id: params[:items_ids]).pluck(:number, :id)]
    suppliers= Hash[Price.collection.aggregate({"$match"=>{artline_item_number:{"$in"=> items.keys}}},
                                               {"$group"=>{_id:"$supplier_id", numbers:{"$addToSet"=>"$artline_item_number"}}}).map(&:values)]

    @project[:po_number] = params[:po_number]
    if @project.valid?
      suppliers.each do |k, v|
        @project.orders.create(supplier_id: k, item_ids: items.slice(*v).values)
      end
      @project.save
      ClientMailer.order_details(@project.id).deliver_now
    end
    respond_to do |format|
      format.html
      format.json {render json: {message: @project.errors.full_messages.to_sentence} }
    end
  end

  def customer_qoute
    if @project.blank?
      render nothing: true, status:404
    else
      @rfqs = @project.rfqs
      @items = @project.items.group_by{|item| !item["number"].blank? || !@rfqs.in(item_ids_quoted: [item.id.to_s]).blank? }
      i=0
      shipping_cost = 0
      if @items[true]
        @product = @items[true].map do |item|
          client_price = Price.find_by(artline_item_number: item["number"]).client_cost(item["additional_charges"].to_i)
          product_details = "#{item['type']} : \n #{item.product.details}"
          [i+=1, product_details, item["quantity"], client_price.round(2), (client_price * item["quantity"].to_i).round(2) ]
        end
        supplier_id =Price.in(artline_item_number: @items[true].map(&:number)).map(&:supplier_id).uniq
        saved_rfqs = @project.rfqs.in(supplier_id: supplier_id)
        shipping_cost = saved_rfqs.sum(:shipping_cost).round(2)
      end
      @product.push(["","","","Shipping Cost", shipping_cost])
      @product.push(["","","","Total", (@product.map{|x| x.last}.inject(:+)).round(2)])

    end
  end

  def send_quotation
    emails = params[:emails].split(',')
    if @project.blank?
      render nothing: true, status:404
    else
      ClientMailer.quote(@project.id,emails).deliver_now
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
