class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  has_many :items, :class_name => 'Products::Item', foreign_key: :category_id
end
