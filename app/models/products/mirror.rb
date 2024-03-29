class Products::Mirror < Product

  field :bevel
  field :bevel_size
  field :bevel_special_instructions
  field :glazing
  field :glazing_special_instructions
  field :glass_width
  field :glass_height
  field :frame_category
  field :frame_size
  field :united_inches
  field :moulding_company_id
  field :frame_id
  field :overall_width
  field :overall_height

  mount_uploader :source, SourceUploader

  def field_names
    %w( )
  end

  def addons
    %w(frame)
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
      self.frame_category = frame.category
      self.frame_size = frame.size
    else
      errors.add(:frame, product.errors.full_messages.join(', '))
    end
  end

  def moulding_company
    MouldingCompany.find(moulding_company_id)
  end

  def frame
    Frame.find(frame_id)
  end

  def size
    0
  end

  def united_inches
    overall_width.to_f + overall_height.to_f
  end

  def description
    ""
  end

  def details
    "Bevel: #{bevel},  Bevel size: #{bevel_size}\n Glazing: #{glazing} \n Glass width: #{glass_width},  Glass height: #{glass_height}\n Frame: #{frame.finish},  Frame size: #{frame_size}\n Moulding company: #{moulding_company.name}\n Overall width: #{overall_width},  Overall height: #{overall_height}"
  end

end
