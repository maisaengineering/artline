class SupplierMailer < ApplicationMailer

  def quote(user_email,supplier_email)
    @current_user = user_email
    @supplier = supplier_email
    mail(from: user_email,to: supplier_email,subject: 'Request Quote')
  end

end
