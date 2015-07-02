class Price
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  belongs_to :companies_supplier, foreign_key: "supplier_id",:class_name => 'Companies::Supplier'
  belongs_to :product

  field :artline_item_number
  field :supplier_item_number
  field :supplier_cost, type: Float
  field :client_cost, type: Float
  field :requester_id, type: String
  field :shipping_cost, type: Float
  field :supplier_note

  attr_accessor :products

  before_validation :assign_artine_number
  before_create :update_projects
  after_create :send_email_to_requester

  def send_email_to_requester
    SupplierMailer.reply_to_requester("#{requester_id}","#{supplier_id}",supplier_cost).deliver_now
  end

  def assign_artine_number
    self.artline_item_number = "#{companies_supplier.number.to_s}#{supplier_item_number.to_s}"
  end

  def update_projects
    Project.elem_match(items:{product_id: product_id}).each do |project|
      project.items.where(product_id: product_id, :quoted.exists=>false).update_all(quoted: true)
      # project.items.where(product_id: product_id).map{|itm| itm.unset(:product_id)}
    end
  end

end
