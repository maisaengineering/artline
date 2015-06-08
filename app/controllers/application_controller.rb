class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: t(:access_denied) #exception.message
  end

  def after_sign_in_path_for(resource_or_scope)
    # if current_user.is?(:super_admin)
    #   oauth_applications_path
    # elsif current_user.is?(:content_writer)
    #   new_post_path
    # else
    #   reset_session
    #   raise CanCan::AccessDenied
    # end
    #
    dashboard_path
  end

end
