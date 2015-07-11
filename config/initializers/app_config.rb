Categories = {"Artwork"=>"Artwork", "Mirror"=>"Mirror",
              "ArtificialPlant"=> "Artificial Plant",
              "Lamp"=>"Lamp"}
Childrens={"Artwork"=>{"framed_art"=>"Framed Art", "acrylic"=>"Acrylic",
                       "aluminum"=>"Aluminum", "colorboard"=>"Colorboard",
                       "vinyl"=>"Vinyl"}}
Addons = {"Bulb"=>"Bulb", "Container"=>"Container",
          "Frame"=> "Frame", "Image"=> "Image",
          "Shade"=>"Shade"}

Artwork = Products::Artwork
ArtificialPlant = Products::ArtificialPlant
Lamp = Products::Lamp
Mirror = Products:: Mirror
Bulb = Products::Addons::Bulb
Container = Products::Addons::Container
Frame = Products::Addons::Frame
Image = Products::Addons::Image
Shade = Products::Addons::Shade
# Other = Product::Other

Client = Companies::Client
Supplier = Companies::Supplier
MouldingCompany = Companies::MouldingCompany