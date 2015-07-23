class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  embedded_in :project


  field :supplier_id
  field :item_ids, type: Array, default:[]
  field :shipment_date # expect shipment date
  field :shipment_details

  after_create :place_order_to_supplier

  def place_order_to_supplier
    SupplierMailer.place_order(id, supplier_id).deliver_now
  end

  STAGE = { 1 =>  "First Stage", 2 => "Second Stage", 3 => "Third Stage", 4 => "Fourth Stage"}

  def items
    @items ||= self.project.items.in(id: item_ids)
  end

  def prices
   @prices =  Hash[Price.in(artline_item_number: items.map(&:number)).map{|price| [price.artline_item_number, price.supplier_cost ]}]
  end

  def supplier
    Supplier.find(supplier_id)
  end

end
