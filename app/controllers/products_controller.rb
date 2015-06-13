class ProductsController < ApplicationController
  def index
     @products = Products::Artwork.paginate(page: params[:page], per_page: 5)
  end

  def new
    # @product = Product.new
  end

  def create
    @product = eval(params[:item_type]).create(product_params)
    unless @product.errors.any?
      redirect_to products_path
    else
      render new
    end
  end


  def load_form
    @product = eval(params[:item]).new
  end

  private

  def product_params
    params.require(:product).permit(params[:product].keys)
  end

end
