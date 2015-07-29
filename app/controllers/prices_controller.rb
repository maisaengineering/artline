class PricesController < ApplicationController
  before_action :authenticate_user!, except: [:new_supplier_price]
  layout "mailer", only: [:new_supplier_price]

  def new_supplier_price
    project= Project.elem_match(rfqs: {_id: BSON::ObjectId.from_string(params[:id])}).first
    @rfq = project.rfqs.find(params[:id])
  end

  def create
    comm_params = product_price_params.slice( "rsq_id")
    product_price_params["products"].each do |product|
      Price.create(product.merge(comm_params))
    end

    project = Project.elem_match(rfqs:{_id: BSON::ObjectId.from_string(params["rsq_id"])}).first unless params["rsq_id"].blank?
    if project
      rsq= project.rfqs.find(params["rsq_id"])
      rsq.update(shipping_cost: params["shipping_cost"]) if rsq
    end
    if params[:created_by_admin].eql?("yes")
      flash[:noice] = "Successfully Updated"
      redirect_to products_url
    else
      render text: "Successfully Updated."
    end
  end

  def update
   @price = Price.where(product_id: params[:product_id], supplier_id: params[:supplier_id])
   @price = @price.update(supplier_cost: params[:supplier_cost]) if @price
   render nothing: true
  end

  private

  def product_price_params
    params.permit!
  end

end