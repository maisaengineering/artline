class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
     @users = User.paginate(page: params[:page], per_page: 5)
  end

  def new
   @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.errors.any?
      render 'new'
    else
      redirect_to project_managers_path, alert: "Project Manager Successfully Created"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "User successfully deleted"
    redirect_to project_managers_path
  end

  private

  def user_params
    params.require(:user).permit(params[:user].keys)
  end
end
