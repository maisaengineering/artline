class SupplierMailer < ApplicationMailer

  def quote(user_id,supplier_id,product_id)
    @user = User.find(user_id)
    @supplier = Company.find(supplier_id)
    @url = "#{root_url}#{product_price_path(id: product_id,supplier_id: @supplier.id,user_id: @user.id)}"
    mail(from: ENV['SENDER'],to: @supplier.email,subject: 'Request Quote')
  end

  def reply_to_requester(user_id,supplier_id,supplier_cost)
    @user = User.find(user_id)
    @supplier = Company.find(supplier_id)
    @supplier_cost = supplier_cost
    mail(from: ENV['SENDER'],to: @user.email,subject: 'Quote reply')
  end

end
