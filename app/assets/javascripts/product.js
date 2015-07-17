$(document).ready(function() {
    $("#product_type").change(function () {
        if( $(this).val() == ""){
           $(".selected_item").empty()
        }
        else if($(this).val() == "Mirror"){
            $('.selected_item').html("<h2>No form</h2>")
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

    new_item = function(element){
        $val= $.trim($(element).val());
        $class_name= $(element).attr('data-name').toLowerCase();
        if($val=='add'){
            var item = $val
            var url = "/products/load_addons"
            $.ajax({
                method: "GET",
                url: url,
                data: {class_name: $class_name}
            })
        }
        else{
            $("." + $class_name).empty()
        }
    }
});
