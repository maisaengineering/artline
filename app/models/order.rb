class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  STAGE = { 1 =>  "First Stage", 2 => "Second Stage", 3 => "Third Stage", 4 => "Fourth Stage"}
end
