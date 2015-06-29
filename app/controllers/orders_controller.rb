class OrdersController < ApplicationController
  layout "mailer", only: [:status]

  def index

  end

  def create_order_tracking
    @shipment = Shipment.create(shipment_params)
    if @shipment
      flash[:notice] = "Successfully Created"
      redirect_to orders_url
    end
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
