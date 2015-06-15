#it as alias to Quote
class Project
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :quote_number #Quote Number
  field :name
  field :date

end
