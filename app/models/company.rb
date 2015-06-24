class Company
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  before_save do
    self.attention = attention.reject(&:blank?).uniq
  end

end
