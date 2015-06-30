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

  def new_moulding_company=(arg)
    moulding_company = MouldingCompany.create(arg)
    unless moulding_company.errors.any?
      self["moulding_company_id"] = moulding_company.id
    else
      errors.add(:name, moulding_company.errors.full_messages.join(', '))
    end
  end

  def new_frame=(arg)
    frame = Frame.create(arg)
    unless frame.errors.any?
      self["frame_id"] = frame.id
    else
      errors.add(:name, frame.errors.full_messages.join(', '))
    end
  end

  def supplier_cost
    item_price.supplier_cost
  end

  def item_price
    @item_price ||= Price.find_by(artline_item_number: self["number"]) if respond_to?(:number)
  end

  def new_container=(arg)
    container = Container.create(arg)
    unless container.errors.any?
      self["container_id"] = container.id
    else
      errors.add(:name, container.errors.full_messages.join(', '))
    end
  end

end
