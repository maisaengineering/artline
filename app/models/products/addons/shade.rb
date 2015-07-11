class Products::Addons::Shade < Products::Addon

  field :description

  mount_uploader :source, SourceUploader

end
