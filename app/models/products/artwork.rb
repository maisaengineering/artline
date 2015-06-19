class Products::Artwork < Product


  field :type
  field :title
  field :artist
  field :publisher_item_number
  field :width    #image width
  field :height   #image height
  field :print_cost
  field :rights_cost

   #need image source field source
  mount_uploader :source, SourceUploader

end
