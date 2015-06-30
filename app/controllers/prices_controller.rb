class PricesController < ApplicationController
  before_action :authenticate_user!
  layout "mailer", only: [:new_supplier_price]

  def new_supplier_price
    @resquest_quote = RequestQuote.find(params[:id])

  end

  def create
    @product_price = Price.create(product_price_params)

    product_price_params[products]
    if @product_price
      flash[:notice] = "price added successfully "
      redirect_to products_url
    end
  end

  private

  def product_price_params
    params.require(:products).permit([:supplier_id, :requester_id, products:[]]+ params[:products].keys)
  end

end