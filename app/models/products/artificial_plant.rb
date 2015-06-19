class Products::ArtificialPlant < Product


  field :plant_name
  field :size


  #need image source field source
  mount_uploader :source, SourceUploader

end
