class Shipment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :po_number,      type: String
  field :stage,          type: String
  field :description,    type: String
end
