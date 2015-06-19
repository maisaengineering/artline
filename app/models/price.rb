class Price
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  belongs_to :companies_supplier, :class_name => 'Companies::Supplier'
  belongs_to :product

  field  :artline_item_number, type: Integer
  field  :supplier_item_number, type: Integer
  field  :supplier_cost, type: Float
  field  :client_cost, type: Float
end
