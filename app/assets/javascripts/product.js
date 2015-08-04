$(document).ready(function() {
    $("#product_type").change(function () {
        if( $(this).val() == ""){
            $(".selected_item").empty()
        }
        else if($(this).val() == "Artwork"){
            var item = $(this).val()
            $.ajax({
                url: "/products/artwork_children",
                method: "GET",
                data: {item: item}
            });
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

    getArtworkForm = function(element){
    var child = $(element).val()
        if(child == ""){
            $('.artwork_form').empty()
        }
        else {
            $.ajax({
                url: "/products/load_form",
                method: "GET",
                data: {item: "Artwork", artwork_children: child}
            });
        }
    }

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

    add_field = function(element){
        var val = $(element).val()
        var field = $(element).attr('data-name').toLowerCase();
        if(val == "add") {
            $("."+ field ).html('<input class="form-control" required="required" type="text" name="product[new_'+ field +'][name]" placeholder="'+ field +'">')
        }
        else{
            $("."+ field).empty()
        }
    }


    upload_img = function(input){
        var filename = input.files[0]
        $('.file-name span').html(filename.name);
    }



    edit_price = function(element){
        var td =  $(element).closest('td')
        var price = $.trim(td.find(".price").html())
        td.find('.row').show()
        td.find("#price").val(price)
        td.find(".price_field").hide()
    }

    update_price = function(element){
        var td =  $(element).closest('td')
        var price = td.find("#price").val()
        var product_id = td.find("#product_id").val()
        var supplier_id = td.find("#supplier_id").val()
        url = "/prices/:id"
        $.ajax({
            method: "PATCH",
            url: url,
            data: {product_id: product_id,supplier_id: supplier_id,supplier_cost: price},
            success: function(data){
                alert("Updated successfully")
                $.trim(td.find(".price").html(price))
                td.find('.row').hide()
                td.find(".price_field").show()
            }
        })
    }


    new_field = function(element){
        $val= $.trim($(element).val());
        $class_name = $(element).attr('data-name').toLowerCase()
        $index = $($(":input[class='"+$(element).attr('class')+"']")).index(element);
        if($val=='add') {
            var str = $class_name.replace("_"," ");
            place_holder = str.replace(/\b[a-z]/g, function(letter) {
                return letter.toUpperCase();
            });
            $(element).replaceWith('<input type="text" name="project[item_list][][product][existing][' + $class_name + ']" id="project_item_list__'+ $class_name +'" class="form-control" placeholder="'+ place_holder +'"  required="required">')
        }
    }
});
