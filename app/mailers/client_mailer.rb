class ClientMailer < ApplicationMailer
  def quote(project_id,emails)
    @project = Project.find(project_id)
    @client = Client.find(@project.client_id)

    rfqs = @project.rfqs
    items = @project.items.group_by{|item| !item["number"].blank? || !rfqs.in(item_ids_quoted: [item.id.to_s]).blank? }
    i=0
    shipping_cost = 0
    if items[true]
      product = items[true].map do |item|
        client_price = Price.find_by(artline_item_number: item["number"]).client_cost(item["additional_charges"].to_i)
        product_details = "#{item['type'].eql?("Artwork") ? item.product.artwork_type.gsub("_"," ") : item['type']} : \n #{item.product.details}"
        [i+=1, product_details, item["quantity"], client_price.round(2), (client_price * item["quantity"].to_i).round(2) ]
      end
      supplier_id =Price.in(artline_item_number: items[true].map(&:number)).map(&:supplier_id).uniq
      saved_rfqs = @project.rfqs.in(supplier_id: supplier_id)
      shipping_cost = saved_rfqs.sum(:shipping_cost).round(2)
    end
    product.push(["","","","Shipping Cost", shipping_cost])
    product.push(["","","","Total", product.map{|x| x.last}.inject(:+).round(2)])

    pdf = Prawn::Document.new(page_layout: :portrait,page_size: 'A4',
                              left_margin: 10,right_margin: 10,top_margin: 10,
                              bottom_margin: 10, background_scale: 300)


     pdf.table product.unshift(["#", "Product","Quantity", "Price per Item" , "Price"]),:header => true if product

    attachments["artline_quote_#{@project.quote_number}.pdf"] = pdf.render
    mail(to: emails,subject: 'Artline Quotation')
  end

  def order_details(id)
    @project  = Project.find(id)
    mail(to: @project.user.email,subject: 'Order Details')
  end

end