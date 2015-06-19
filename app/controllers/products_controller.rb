class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show,:edit, :update, :destroy]

  def index
    @products = Product.order_by(created_at: "desc").paginate(page: params[:page], per_page: 5)
  end

  def new
    # @product = Product.new
  end

  def create
    @product = eval(params[:item_type]).create(product_params)
    unless @product.errors.any?
      redirect_to product_url(@product)
    else
      render new
    end
  end

  def show
   @suppliers = Supplier.all
  end

  def edit

  end

  def update
    if @product.update(product_params)
      flash[:noice] = "Successfully Updated"
      redirect_to product_url(@product)
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    flash[:notice]= "Item successfully deleted"
    redirect_to products_url
  end


  def load_form
    @product = eval(params[:item]).new
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(params[:product].keys)
  end

end
