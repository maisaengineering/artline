class Companies::Supplier < Company

  has_many :prices
  has_many :request_quotes

end