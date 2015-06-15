$(document).ready(function() {
    $("#product_type").change(function () {
        if (($(this).val() == "Artwork") || ($(this).val() == "ArtificialPlant") ||  ($(this).val() == "Lamp")) {
            $('.selected_item').show()
            var item = $(this).val()
            var url = "/products/load_form"
            $.ajax({
                method: "GET",
                url: url,
                dataType: 'script',
                data: {item: item}
            })
        }
        else {
            $('.selected_item').html("<h2>No form</h2>")
        }
    });

    upload_img = function(input){
        var filename = input.files[0]
        $('.file-name span').html(filename.name);
    }
});
