

prawn_document(:page_layout => :landscape) do |pdf|
  pdf.font_size 25
  pdf.draw_text "ARTLINE", at: [350,500]
  pdf.font_size 15
  pdf.move_down 50
  pdf.text "Artline Quote Number: #{@project.quote_number}"
  pdf.move_down 12
  pdf.table @product.unshift(["#", "Product","Quantity", "Each price" , "Price"]),:header => true if @product

end