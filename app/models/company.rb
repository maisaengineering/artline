class Company
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :name
  field :attention, type: Array
  field :email

  index({"name" => "text"},{background: true})


  before_save do
    self.attention = attention.reject(&:blank?).uniq
  end

end
