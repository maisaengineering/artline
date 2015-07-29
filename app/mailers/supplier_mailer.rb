class SupplierMailer < ApplicationMailer

  def quote(id, email)
    @rsq_id = id
    mail( to: email,subject: 'Artline: Quotation Needed')
  end

  def reply_to_requester(user_id,supplier_id,supplier_cost)
    @user = User.find(user_id)
    @supplier = Company.find(supplier_id)
    @supplier_cost = supplier_cost
    mail(to: @user.email,subject: 'Quotation')
  end

  def place_order(id, supplier_id)
   @order_id= id
   @supplier = Company.find(supplier_id)
   mail(to: @supplier.email,subject: 'Artline Order')
  end

end
