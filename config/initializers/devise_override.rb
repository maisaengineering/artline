Devise::RegistrationsController.class_eval do
  skip_before_filter :require_no_authentication, only: [:new, :create]
  prepend_before_filter :authenticate_scope!, only: [:new, :create, :edit, :update, :destroy]

  prepend_before_action do
    resource = controller_name.singularize.to_sym
    method = "account_update_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
  load_and_authorize_resource :class => "User"

  def account_update_params
    params.require(:user).permit(params[:user].keys)
  end

end