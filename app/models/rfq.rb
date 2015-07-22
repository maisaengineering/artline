class RFQ
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps

  field :supplier_id
  field :item_ids_to_quote, type: Array, default:[]
  field :item_ids_quoted, type: Array, default:[]
  field :shipping_cost, type: Float
  embedded_in :project

  after_create :send_email

  def supplier
    Companies::Supplier.find(supplier_id)
  end

  def send_email
    SupplierMailer.quote(id, supplier.email).deliver_now
  end

  def items_to_quote
    self.project.items.in(id: item_ids_to_quote)
  end

  def items_qouted
    self.project.items.in(id: item_ids_quoted)
  end

end