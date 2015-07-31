class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show,:edit, :update, :destroy]

  def index
    @products = Product.where(:_type.ne =>  "Products::Mirror").order_by(created_at: "desc").paginate(page: params[:page], per_page: 5)
  end

  def new
    @type = params[:type]
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
    #@suppliers = Supplier.all
    if Categories.keys.include?@product._type.split("::").last
      @quoted = Price.where(product_id: @product.id)
      @non_quoted_supplier = Companies::Supplier.nin(id: @quoted.pluck(:supplier_id))
    end
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

  def load_addons

  end

  def prefill_data
    quote = Price.where(artline_item_number: params[:artline_number]).first unless params[:addon]
    product = params[:addon] ? Product.where(id: params[:artline_number]).first : quote.product
    render json: case product.class.to_s.split("::").last
                   when 'Lamp'
                     {"shade_id"=> product.shade_id.to_s, "bulb_id"=> product.bulb_id.to_s}
                   when 'ArtificialPlant'
                     {"fire_rating"=>product.fire_rating, "container_id"=>product.container_id.to_s}
                   when 'Frame'
                     product.attributes.slice("category", "size")
                   when 'Image'
                     product.attributes.slice("title", "width", "height")
                   else
                     {}
                 end

  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit!
  end

end
