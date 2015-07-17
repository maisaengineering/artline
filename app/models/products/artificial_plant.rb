class Products::ArtificialPlant < Product


  field :name
  field :size
  field :fire_rating
  field :container_id


  #need image source field source
  mount_uploader :source, SourceUploader

  def field_names
    %w(plant_name size)
  end

  def addons
    %w(container)
  end

  def number=(arg)
    price = Price.find_by(artline_item_number:arg)
    if price and price.product
      self.name = price.product.name
      self.size = price.product.size
    end
  end

  def container=(arg)
    product= Container.create(arg)
    unless product.errors.any?
      self.container_id = product.id
    else
      errors.add(:container, product.errors.full_messages.join(', '))
    end
  end

  def container
    Container.find(container_id)
  end


  def self.artine_item_numbers
    Price.in(product_id: ArtificialPlant.pluck(:id)).pluck(:artline_item_number)
  end

  def description
    name
  end

  def details
    "#{description} \n size: #{size} \n Container: #{container.name}"
  end
end
