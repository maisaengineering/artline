class Products::Lamp < Product

  field :description
  field :size

  #need image source field source
  mount_uploader :source, SourceUploader

end
