class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:show,:tracking,:enter_shipment_details,:update]
  before_action :set_order, only: [:show, :update,:enter_shipment_details]
  layout "mailer", only: [:show,:tracking,:enter_shipment_details]

  def index
    if current_user.is?(:super_admin)
       @projects = Project.where(:po_number.exists=>true).desc(:created_at).paginate(page: params[:page], per_page: 5)
    else
      @projects = current_user.projects.where(:po_number.exists=>true).desc(:created_at).paginate(page: params[:page], per_page: 5)
    end
  end

  def create_order_tracking
    @shipment = Shipment.create(shipment_params)
    if @shipment
      flash[:notice] = "Successfully Created"
      redirect_to orders_url
    end
  end

  def show
    render nothing: true unless @order
  end

  def update
    @order.update(shipment_details)
    respond_to do |format|
      format.html {render text: "Successfully Updated."}
      format.json {render json: {message: "Successfully Updated"} }
    end
  end

  def tracking
    @project = Project.find(params[:id])
  end

  def status
    @project = Project.find(params[:id])
  end

  def search
    @projects = Project.where("$text"=>{"$search"=>params["key"]}).and(:po_number.exists=>true).desc(:created_at).paginate(page: params[:page], per_page: 5)
    render 'index'
  end

  def enter_shipment_details
   
  end

  private

  def set_order
    project= Project.elem_match(orders: {_id: BSON::ObjectId.from_string(params[:id])}).first
    @order = project.orders.find(params[:id]) if project
  end

  def shipment_params
    params.require(:shipment).permit(params[:shipment].keys)
  end

  def shipment_details
    params.require(:order).permit(:shipment_date, :shipment_details)
  end

end
