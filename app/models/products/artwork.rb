class Products::Artwork < Product


  #field :type
  field :title
  field :width    #image width
  field :height   #image height
  field :supplier_id
  field :moulding_company_id
  field :frame_id
  field :image_id
  field :board_option
  field :acrylic_thickness
  field :matting
  field :mat_size
  field :mat_special_instructions
  field :glazing
  field :glazing_special_instructions
  field :glass_width
  field :glass_height
  field :glass_united_inches
  field :category
  field :frame_size
  field :overall_width
  field :overall_height

   #need image source field source
  mount_uploader :source, SourceUploader

  def field_names
    %w(title artist width height source)
  end

  def addons
    %w(frame)
  end

  def image=(arg)
    image = Image.create(arg)
    unless image.errors.any?
      self.image_id = image.id
      self.width = image.width
      self.height = image.height
    else
      errors.add(:image, product.errors.full_messages.join(', '))
    end
  end

  def supplier=(arg)
    supplier= Supplier.create(arg)
    unless supplier.errors.any?
      self.supplier_id = supplier.id
    else
      errors.add(:supplier, product.errors.full_messages.join(', '))
    end
  end

  def moulding_company=(arg)
    company = MouldingCompany.create(arg)
    unless company.errors.any?
      self.moulding_company_id = company.id
    else
      errors.add(:moulding_company, product.errors.full_messages.join(', '))
    end
  end

  def frame=(arg)
    frame = Frame.create(arg)
    unless frame.errors.any?
      self.frame_id = frame.id
    else
      errors.add(:frame, product.errors.full_messages.join(', '))
    end
  end

  def new_board_option=(arg)
    self.board_option = arg[:name]
  end

  def new_acrylic_thickness=(arg)
    self.acrylic_thickness = arg[:name]
  end

  def new_matting=(arg)
    self.matting = arg[:name]
  end

  def supplier
    Supplier.find(supplier_id)
  end

  def moulding_company
    MouldingCompany.find(moulding_company_id)
  end

  def frame
    Frame.find(frame_id)
  end

  def image
    Image.find(image_id)

  end

  def self.artine_item_numbers
    Price.in(product_id: Artwork.pluck(:id)).pluck(:artline_item_number)
  end


  def details
     "Publisher: #{supplier.name}\n Image: #{image["title"]}  Artist: #{image.artist}\n Title: #{title} \n Width: #{width}\n Height: #{height}"
  end

  def glass_united_inches
    self["glass_width"].to_i + self["glass_height"].to_i
  end

end
