class Products::Lamp < Product

  field :supplier_item_number
  field :number  #artline Item Number
  field :description
  field :size
  field :supplier_price

  #need image source field source
  mount_uploader :source, SourceUploader

end
