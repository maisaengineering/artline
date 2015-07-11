class Products::Addons::Image < Products::Addon

  field :title
  field :artist
  field :width
  field :height

  mount_uploader :source, SourceUploader

end
