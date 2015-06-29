class Price
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  belongs_to :companies_supplier, foreign_key: "supplier_id",:class_name => 'Companies::Supplier'
  belongs_to :product

  after_create :send_email_to_requester

  field  :artline_item_number
  field  :supplier_item_number
  field  :supplier_cost, type: Float
  field  :client_cost, type: Float
  field  :requester_id, type: String

  before_validation :assign_artine_number, on: :update

  def send_email_to_requester
    SupplierMailer.reply_to_requester("#{requester_id}","#{companies_supplier_id}",supplier_cost).deliver_now
  end

  def assign_artine_number
    self.artline_item_number = "#{companies_supplier.number}#{supplier_item_number}"
  end
end
