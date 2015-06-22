class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  def index
    @companys = Company.order_by(created_at: "desc").paginate(page: params[:page], per_page: 5)
  end

  def new
    respond_to do |format|
      format.html
      format.js { render partial: 'form', locals:{_type: params[:_type]}}
    end
  end

  def create
    @company = eval(params[:_type]).create(company_params)
    if @company.save
      redirect_to companies_url
    else
      render :new
    end
  end

  def show
    if @company
      respond_to do |format|
        format.html
        format.json {render json: @company }
      end
    else
      render nothing: true, status:404
    end
  end

  def edit

  end

  def update
    if @company.update(company_params)
      flash[:notice] = "Successfully Updated"
      redirect_to companies_url
    else
      flash[:notice] = "not updated"
      render :edit
    end
  end

  def destroy
    if @company.destroy
      flash[:notice] = "Successfully deleted"
      redirect_to companies_url
    else
      flash[:notice] = "Record Not found"
      redirect_to companies_url
    end
  end

  def create_request_quote
    params[:request_quote][:supplier_id].each do |supplier_id|
      current_user.request_quotes.create(item_id: params[:request_quote][:item_id],supplier_id: supplier_id)
    end
    flash[:notice] = "Request successfully sent"
    redirect_to products_url
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(params[:company].keys)
  end

end
