class Products::Addons::Container < Products::Addon

  field :name

  def details
    name
  end
end
