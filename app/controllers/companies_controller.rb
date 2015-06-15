class CompaniesController < ApplicationController

  def new
    respond_to do |format|
      format.html
      format.js { render partial: 'form', locals:{_type: params[:_type]}}
    end
  end

  def create
    @company = eval(company_params[:_type]).create(company_params)
  end

  def show
    @company = Company.find(params[:id])
    if @company
      respond_to do |format|
        format.html
        format.json {render json: @company }
      end
    else
      render nothing: true, status:404
    end


  end

  private

  def company_params
    params.require(:company).permit(params[:company].keys)
  end

end
