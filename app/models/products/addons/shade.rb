class Products::Addons::Shade < Products::Addon

  field :description

   def details
     description
   end
end
