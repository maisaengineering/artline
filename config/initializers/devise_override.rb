Devise::RegistrationsController.class_eval do
  prepend_before_filter :require_no_authentication, only: [:cancel]
  prepend_before_filter :authenticate_scope!, only: [:new, :create, :edit, :update, :destroy]
end