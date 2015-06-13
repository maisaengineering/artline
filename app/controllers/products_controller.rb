class ProductsController < ApplicationController
  def index

  end

  def new

  end

  def create
    @item = eval(params[:itemtype]).create(item_params)
    unless @item.errors.any?
    else
    end
  end


  def load_form
  end

  private

  def item_params
    params.require(:item).permit(params[:item].keys)
  end

end
