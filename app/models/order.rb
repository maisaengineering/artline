class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  embedded_in :project


  field :supplier_id
  field :item_ids, type: Array, default:[]
  field :shipment_date
  field :shipment_details

  after_create :place_order_to_supplier

  def place_order_to_supplier
    SupplierMailer.place_order
  end



  STAGE = { 1 =>  "First Stage", 2 => "Second Stage", 3 => "Third Stage", 4 => "Fourth Stage"}
end
