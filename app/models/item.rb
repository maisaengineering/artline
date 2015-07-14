class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :number

  embedded_in :project

  def product=(arg)
    if arg.include?('new')
      product = eval(type).new(arg['new'])
      product.assign_attributes(arg['existing'])
    else
      price = Price.find_by(artline_item_number:arg['existing']['number'] )
      org_prod = price.product if price and price.product
      product = eval(type).where(arg['existing'].reject{|k,v| k.eql?("number")}).find_or_initialize_by.tap do |pro|
        org_prod.field_names.each do |pfield|
          pro[pfield] = org_prod[pfield]
        end if org_prod
      end
      self["number"] = arg['existing']['number'] if !product.new_record? and product.eql?(org_prod)
    end
    product.save
    unless product.errors.any?
      self["product_id"] = product.id
    else
      errors.add(:new_item, product.errors.full_messages.join(', '))
    end
  end

  def product
    @product ||= Product.find(self["product_id"])
  end

  # def new_product=(arg)
  #   product = eval(type).create(arg)
  #
  #   unless product.errors.any?
  #     self["product_id"] = product.id
  #   else
  #     errors.add(:new_item, product.errors.full_messages.join(', '))
  #   end
  # end

  # def new_shade=(arg)
  #   product= Shade.create(arg)
  #   unless product.errors.any?
  #     self["shade_id"] = product.id
  #   else
  #     errors.add(:new_shade, product.errors.full_messages.join(', '))
  #   end
  # end
  #
  # def new_bulb=(arg)
  #   product = Bulb.create(arg)
  #   unless product.errors.any?
  #     self["bulb_id"] = product.id
  #   else
  #     errors.add(:new_shade, product.errors.full_messages.join(', '))
  #   end
  # end
  #
  # def new_moulding_company=(arg)
  #   moulding_company = MouldingCompany.create(arg)
  #   unless moulding_company.errors.any?
  #     self["moulding_company_id"] = moulding_company.id
  #   else
  #     errors.add(:name, moulding_company.errors.full_messages.join(', '))
  #   end
  # end
  #
  # def new_frame=(arg)
  #   frame = Frame.create(arg)
  #   unless frame.errors.any?
  #     self["frame_id"] = frame.id
  #   else
  #     errors.add(:name, frame.errors.full_messages.join(', '))
  #   end
  # end

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

  def new_supplier=(arg)
    supplier = Supplier.create(arg)
    unless supplier.errors.any?
      self["supplier_id"] = supplier.id
    else
      errors.add(:name, supplier.errors.full_messages.join(', '))
    end
  end

end
