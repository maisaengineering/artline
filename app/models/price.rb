class Price
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  belongs_to :companies_supplier, :class_name => 'Companies::Supplier'
  belongs_to :product

  after_create :send_email_to_requester

  field  :artline_item_number, type: Integer
  field  :supplier_item_number, type: Integer
  field  :supplier_cost, type: Float
  field  :client_cost, type: Float
  field  :requester, type: String

  def send_email_to_requester
    SupplierMailer.reply_to_requester("#{requester}","#{companies_supplier_id}",supplier_cost).deliver_now
  end
end
