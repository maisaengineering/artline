class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  embedded_in :project

  def new_product=(arg)
    product = eval(type).create(arg)

    unless product.errors.any?
      self["product_id"] = product.id
    else
      errors.add(:new_item, product.errors.full_messages.join(', '))
    end
  end

  def new_shade=(arg)
    product= Shade.create(arg)
    unless product.errors.any?
      self["shade_id"] = product.id
    else
      errors.add(:new_shade, product.errors.full_messages.join(', '))
    end
  end

  def new_bulb=(arg)
    product = Bulb.create(arg)
    unless product.errors.any?
      self["bulb_id"] = product.id
    else
      errors.add(:new_shade, product.errors.full_messages.join(', '))
    end
  end

end
