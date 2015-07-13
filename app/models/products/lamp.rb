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


end
