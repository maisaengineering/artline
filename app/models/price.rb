class Price
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  belongs_to :companies_supplier, foreign_key: "supplier_id",:class_name => 'Companies::Supplier'
  belongs_to :product

  field :artline_item_number
  field :supplier_item_number
  field :supplier_cost, type: Float
  # field :client_cost, type: Float
  field :project_id, type: String
  # field :shipping_cost, type: Float
  field :supplier_note

  attr_accessor :rsq_id, :item_id

  before_validation :assign_artine_number, unless: Proc.new{|pro| pro.rfq.nil?}
  before_create :update_projects, unless: Proc.new{|pro| pro.rfq.nil?}
  before_create :add_artine_number, if:  Proc.new{|pro| pro.rfq.nil?}
  after_create :send_email_to_requester, unless: Proc.new{|pro| pro.rfq.nil?}

  def send_email_to_requester
    SupplierMailer.reply_to_requester("#{rfq.project.user_id}","#{supplier_id}",supplier_cost).deliver_now
  end

  def assign_artine_number
    self.project_id = rfq.project.id
    self.supplier_id = rfq.supplier_id
    self.artline_item_number = "#{companies_supplier.number.to_s}#{supplier_item_number.to_s}"
  end

  def add_artine_number
    self.artline_item_number = "#{companies_supplier.number.to_s}#{supplier_item_number.to_s}"
  end

  def rfq
    @rfq||= Project.elem_match(rfqs:{_id: BSON::ObjectId.from_string(rsq_id)}).first.rfqs.find(rsq_id) if rsq_id.present?
  end

  def client_cost(percentage=2)
    !supplier_cost.blank? ? supplier_cost+ (supplier_cost*percentage/100) : 0
  end


  def update_projects
    if rfq
      rfq.pull(item_ids_to_quote: item_id)
      rfq.push(item_ids_quoted: item_id)
    end
  end

end
