class Products::ArtificialPlant < Product

  field :supplier_item_number
  field :number  #artline Item Number
  field :plant_name
  field :size
  field :supplier_price

  #need image source field source
  mount_uploader :source, SourceUploader

end
