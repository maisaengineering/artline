class SupplierMailer < ApplicationMailer

  def quote(user_id,supplier_id,product_id)
    @current_user = User.find(user_id)
    @supplier = Company.find(supplier_id)
    @url = "#{root_url}#{product_price_path(id: product_id,supplier_id: @supplier.id)}"
    mail(from: @current_user.email,to: @supplier.email,subject: 'Request Quote')
  end

end
