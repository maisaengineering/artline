class OrdersController < ApplicationController
  layout "mailer", only: [:status, :show]

  def index
    @projects = Project.where(:po_number.exists=>true).desc(:created_at).paginate(page: params[:page], per_page: 5)
  end

  def create_order_tracking
    @shipment = Shipment.create(shipment_params)
    if @shipment
      flash[:notice] = "Successfully Created"
      redirect_to orders_url
    end
  end

  def show
    project= Project.elem_match(orders: {_id: BSON::ObjectId.from_string(params[:id])}).first
    @order = project.orders.find(params[:id]) if project
    render nothing: true unless @order
   end

  def tracking

  end

  def status
    @shipment = Shipment.find_by(po_number: params[:id])
  end

  private

  def shipment_params
    params.require(:shipment).permit(params[:shipment].keys)
  end

end
