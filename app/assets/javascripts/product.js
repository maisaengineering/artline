$(document).ready(function() {
    $("#product_type").change(function () {
        if( $(this).val() == ""){
           $(".selected_item").empty()
        }
        else {
            var item = $(this).val()
            var url = "/products/load_form"
            $.ajax({
                method: "GET",
                url: url,
                dataType: 'script',
                data: {item: item}
            })
        }
    });

    upload_img = function(input){
        var filename = input.files[0]
        $('.file-name span').html(filename.name);
    }
});
