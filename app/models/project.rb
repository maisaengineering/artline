#it as alias to Quote
class Project
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  include Mongoid::Paranoia


  field :quote_number #Quote Number
  field :name
  field :date, type: DateTime
  field :client_id
  field :client_attention
  field :company_name
  field :company_email
  field :sales_rep
  field :po_number

  attr_accessor :item_list, :new_attention

  validates :po_number, uniqueness: true, :allow_nil => true, :allow_blank => true

  before_validation :generate_quote_number
  before_save :update_new_attention, unless: Proc.new{|pro| pro.new_attention.blank?}

  belongs_to :user
  embeds_many :items
  embeds_many :rfqs, class_name: 'RFQ'
  embeds_many :orders
  index({"quote_number"=> 'text', "name"=> 'text', "company_name"=>'text', "company_email"=>'text', "po_number"=>'text'},{background: true})

  def item_list=(args)
    args.map do |arg|
      if !new_record? and arg.include?("id")
        item = items.find(arg["id"])
        item.update(arg) if item
      else
        self.items.build(arg)
      end

    end
  end

  def company=(args)
    if client_id.blank?
      client = Client.create(args)
      self.client_attention = client.attention.first
    else
      client = Client.find(client_id)
      client.update(args.reject{|k, v| (k == "attention") || ( k == "new_attention_name")})
      if args[:new_attention_name].present?
        client.push(attention: args[:new_attention_name])
        self.client_attention = args[:new_attention_name]
      end
    end

    unless client.errors.any?
      self.client_id = client.id
      self.company_name= client.name
      self.company_email= client.email
    else
      errors.add(:company,client.errors.full_messages.join(','))
    end
  end

  def new_sales_rep=(args)
    sales_rep = SalesRep.create(args)
    self.sales_rep = sales_rep.name
  end

  def client
    Client.find(client_id)
  end


private

  def update_new_attention
    client = Client.find(client_id)
    client.add_to_set(attentions: new_attentions)
    self.client_attention = new_attentions
  end

  def generate_quote_number
    count = Project.count
    u_id = "#{name.slice(0..2).to_s.upcase}#{Time.now.day}#{count}"
    loop do
      break if self.class.where(quote_number: u_id).blank?
      u_id = "#{name.slice(0..2).to_s.upcase}#{Time.now.day}#{count+=1}"
    end
    self.quote_number ||= u_id
  end

end
