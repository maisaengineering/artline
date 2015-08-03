class Companies::Supplier < Company

  field :number
 # field :name


  has_many :prices
  has_many :request_quotes

  before_validation :assign_supperier_number

  def assign_supperier_number
    self.number ||= generate_number
  end

  def generate_number
    charset = ('A'..'Z').to_a+(1..9).to_a
    tk =  "SP#{(0...4).map{ charset.to_a[rand(charset.size)] }.join}"
    loop do
      break unless Companies::Supplier.where(number:/^#{tk}$/i).exists?
      tk =  "SP#{(0...4).map{ charset.to_a[rand(charset.size)] }.join}"
    end
    tk
  end

end