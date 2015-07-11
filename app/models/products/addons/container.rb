class Products::Addons::Container < Products::Addon

  field :name

  mount_uploader :source, SourceUploader

end
