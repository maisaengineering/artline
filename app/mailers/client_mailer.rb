class ClientMailer < ApplicationMailer
  def quote(project_id,emails)
    @project = Project.find(project_id)
    @client = Client.find(@project.client_id)

    rfqs = @project.rfqs
    items = @project.items.group_by{|item| !item["number"].blank? || !rfqs.in(item_ids_quoted: [item.id.to_s]).blank? }
    i=0
    product = items[true].map do |item|
      client_price = Price.find_by(artline_item_number: item["number"]).client_cost(item["additional_charge"].to_i)
      product_details = "#{item['type']} : \n #{item.product.details}"
      [i+=1, product_details, item["quantity"], client_price, client_price * item["quantity"].to_i ]
    end if items[true]
    product.push(["","","","Shipping Cost", 0])
    product.push(["","","","Total", product.map{|x| x.last}.inject(:+)])

    pdf = Prawn::Document.new(page_layout: :portrait,page_size: 'A4',
                              left_margin: 10,right_margin: 10,top_margin: 10,
                              bottom_margin: 10, background_scale: 300)


     pdf.table product.unshift(["#", "Product","Quantity", "Each price" , "Price"]),:header => true if product

    attachments["artline_quote_#{@project.quote_number}.pdf"] = pdf.render
    mail(from: ENV['SENDER'],to: emails,subject: 'Artline Quotation')
  end

end