class SupplierMailer < ApplicationMailer

  def quote(id, email)
    @rsq_id = id
    mail(from: ENV['SENDER'],to: email,subject: 'Request Quote')
  end

  def reply_to_requester(user_id,supplier_id,supplier_cost)
    @user = User.find(user_id)
    @supplier = Company.find(supplier_id)
    @supplier_cost = supplier_cost
    mail(from: ENV['SENDER'],to: @user.email,subject: 'Quote reply')
  end

end
