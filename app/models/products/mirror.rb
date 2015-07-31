class Products::Mirror < Product

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
      # self.frame_category = frame.category
      # self.frame_size = frame.size
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

end
