class SupplierMailer < ApplicationMailer

  def quote(user_email,supplier_email,product_id)
    @current_user = user_email
    @supplier = supplier_email
    @url = "#{root_url}#{product_price_path(id: product_id)}"
    mail(from: user_email,to: supplier_email,subject: 'Request Quote')
  end

end
