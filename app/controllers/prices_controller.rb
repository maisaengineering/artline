class PricesController < ApplicationController
  before_action :authenticate_user!
  layout "mailer", only: [:create_supplier_price]

  def create_supplier_price
    @product = Product.find(params[:id])
    @supplier = Company.find(params[:supplier_id])
    @user = User.find(params[:user_id])
  end

  def update_product_price
    @product = Product.find(params[:id])
    @product_price = @product.prices.create(product_price_params)
    if @product_price
      flash[:notice] = "price added successfully "
      redirect_to products_url
    end
  end

  private

  def product_price_params
    params.require(:product).permit(params[:product].keys)
  end

end