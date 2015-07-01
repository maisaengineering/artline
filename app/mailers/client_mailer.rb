class ClientMailer < ApplicationMailer
  def quote(project_id)
    @project = Project.find(project_id)
    @client = Client.find(@project.client_id)
    items = @project.items.group_by{|item| !item["number"].blank?}
    i=0
    product = items[true].map{|item| [i+=1, item["type"], item["number"], item["quantity"], item.supplier_cost]} if items[true]
    pdf = Prawn::Document.new(page_layout: :portrait,page_size: 'A4',
                              left_margin: 10,right_margin: 10,top_margin: 10,
                              bottom_margin: 10, background_scale: 300)


     pdf.table product.unshift(["#", "Product","Artline Item Number","Quantity", "price"]),:header => true if product

    attachments["artline_quote_#{@project.quote_number}.pdf"] = pdf.render
    mail(from: ENV['SENDER'],to: @client.email,subject: 'Artline Quotation')
  end

end