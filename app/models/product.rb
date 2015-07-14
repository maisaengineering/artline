class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  has_many :prices

  def details

  end
end
