product = @items.pluck(:type,:number,:quantity) if @items[true]

prawn_document(:page_layout => :landscape) do |pdf|
  pdf.font_size 15
  pdf.text "Product"
  pdf.table product.unshift(["Product","Artline Item Number","Quantity"]),:header => true if product

end