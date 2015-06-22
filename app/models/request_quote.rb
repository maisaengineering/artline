class RequestQuote
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :companies_supplier, foreign_key: "supplier_id", :class_name => 'Companies::Supplier'

  after_create :send_email

  field :item_id

  def send_email
    SupplierMailer.quote("#{user_id}","#{supplier_id}",item_id).deliver_later
  end

end
