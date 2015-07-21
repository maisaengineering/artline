class Products::Lamp < Product


  field :description
  field :size
  field :shade_id
  field :bulb_id

  #need image source field source
  mount_uploader :source, SourceUploader

  def field_names
    %w(description size)
  end

  def addons
    %w(shade bulb)
  end

  def number=(arg)
    price = Price.find_by(artline_item_number:arg)
    if price and price.product
      self.description = price.product.description
      self.size = price.product.size
    end
  end

  def shade=(arg)
    product= Shade.create(arg)
    unless product.errors.any?
      self.shade_id = product.id
    else
      errors.add(:shade, product.errors.full_messages.join(', '))
    end
  end

  def bulb=(arg)
    product= Bulb.create(arg)
    unless product.errors.any?
      self.bulb_id = product.id
    else
      errors.add(:bulb, product.errors.full_messages.join(', '))
    end
  end

  def shade
    Shade.find(shade_id)
  end

  def bulb
    Bulb.find(bulb_id)
  end

  def details
    "#{description} \n size: #{size} \n Shade: #{shade.description}\n Bulb: #{bulb.description}"
  end

  def self.artine_item_numbers
    Price.in(product_id: only(:id).all.map(&:id)).only(:artline_item_number).map(&:artline_item_number)
  end

end
