i=0
product = @items[true].map{|item| [i+=1, item["type"], item["number"], item["quantity"],Price.any_of({product_id: item["product_id"]},{artline_item_number: item["number"]}).asc(:supplier_cost).map{|c| c.supplier_cost.to_f + c.shipping_cost.to_f}[0], Price.any_of({product_id: item["product_id"]},{artline_item_number: item["number"]}).asc(:supplier_cost).map{|c| c.supplier_cost.to_f + c.shipping_cost.to_f}[0] * item["quantity"] ]} if @items[true]

prawn_document(:page_layout => :landscape) do |pdf|
  pdf.font_size 25
  pdf.draw_text "ARTLINE", at: [350,500]
  pdf.font_size 15
  pdf.move_down 50
  pdf.text "Artline Quote Number: #{@project.quote_number}"
  pdf.move_down 12
  pdf.table product.unshift(["#", "Product","Artline Item Number","Quantity", "Single price" , "Total Price"]),:header => true if product

end