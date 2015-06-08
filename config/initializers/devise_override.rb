Devise::RegistrationsController.class_eval do
  skip_before_filter :require_no_authentication, only: [:new, :create]
  prepend_before_filter :authenticate_scope!, only: [:new, :create, :edit, :update, :destroy]
  load_and_authorize_resource :class => "User"
end