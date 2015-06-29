class RequestQuote
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :companies_supplier, foreign_key: "supplier_id", :class_name => 'Companies::Supplier'

  after_create :send_email

  field :item_ids, type: Array

  def products
    Product.in(id: item_ids)
  end


  def send_email
    SupplierMailer.quote(id, companies_supplier.email).deliver_now
  end

end
