i=0
product = @items[true].map{|item| [i+=1, item["type"], item["number"], item["quantity"], item.supplier_cost]} if @items[true]

prawn_document(:page_layout => :landscape) do |pdf|
  pdf.font_size 15
  pdf.text "Artline Quote Number: #{@project.quote_number}"
  pdf.move_down 20
  pdf.table product.unshift(["#", "Product","Artline Item Number","Quantity", "price"]),:header => true if product

end