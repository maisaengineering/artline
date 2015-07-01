class PricesController < ApplicationController
  before_action :authenticate_user!, except: [:new_supplier_price]
  layout "mailer", only: [:new_supplier_price]

  def new_supplier_price
    @resquest_quote = RequestQuote.find(params[:id])

  end

  def create
    comm_params = product_price_params.slice("supplier_id","requester_id")
    product_price_params["products"].each do |product|
      Price.create(product.merge(comm_params))
    end
    render text: "Successfully Updated."
  end

  private

  def product_price_params
    params.permit!
  end

end