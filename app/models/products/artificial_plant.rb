class Products::ArtificialPlant < Product


  field :plant_name
  field :size
  field :container_id


  #need image source field source
  mount_uploader :source, SourceUploader

  def number=(arg)
    price = Price.find_by(artline_item_number:arg)
    if price and price.product
      self.description = price.product.description
      self.size = price.product.size
    end
  end

  def container=(arg)
    product= Container.create(arg)
    unless product.errors.any?
      self.container_id = product.id
    else
      errors.add(:shade, product.errors.full_messages.join(', '))
    end
  end

  def container
    Container.find(container_id)
  end


  def self.artine_item_numbers
    Price.in(product_id: Lamp.pluck(:id)).pluck(:artline_item_number)
  end
end
