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
            $(element).closest('.row').nextAll('.replaceable:first').find("input").attr("disabled", true)
            $(element).closest('.row').nextAll('.replaceable:first').hide()
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
            if( ($class_name == "mouldingcompany") || ($class_name == "supplier")){
                return false;
            }
            $(element).closest('.row').nextAll('.replaceable:first').show()
            $(element).closest('.row').nextAll('.replaceable:first').find("input").attr("disabled", false)
            var data = new Object({class_name: $class_name, artline_number: $val});
            if($(element).attr('data-addon')){
                data["addon"]=true;
            }
            var url = "/products/prefill_data";
            $.ajax({
                method: "GET",
                url: url,
                dataType: 'json',
                data: data,
                success: function(data){
                    switch($class_name) {
                        case "frame":
                            $elementRow = $(element).closest('.row').nextAll(".row");
                            $elementRow.find("input[id$='product_category'], input[id$='product_frame_category']:eq(0)").val(data.category);
                            $elementRow.find("input[id$='product_frame_size']:eq(0)").val(data.size);
                            $elementRow.find("input[id$='frame_size']:eq(0)").trigger('change');
                            break;
                        case "image":
                            $elementRow = $(element).closest('.row').nextAll(".replaceable");
                            $elementRow.find("input[id$='product_title']:eq(0)").val(data.title);
                            $elementRow.find("input[id$='product_width']:eq(0)").val(data.width);
                            $elementRow.find("input[id$='product_height']:eq(0)").val(data.height);
                            $elementRow.find("input[id$='product_width']:eq(0), input[id$='product_height']:eq(0)").trigger('change');
                            break;
                    }
                }
            })
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



    glass_width= function(element){
        $val = eval($(element).val() || 0);
        $element_row = $(element).closest('.row');
        $frame_size = eval($element_row.nextAll('div').find("input[id$='frame_size']:eq(0)").val() || 0);
        $overall_width_element = $element_row.nextAll('.row').find("input[id$='overall_width']:eq(0)");
        $overall_height_element = $element_row.nextAll('.row').find("input[id$='overall_height']:eq(0)");
        $overall_width_element.val($val+2*$frame_size);
        $element_row.nextAll('.row').find("input[id$='united_inches']:eq(0)").val(eval($overall_width_element.val())+eval($overall_height_element.val()));
    }

    glass_height= function(element){
        $val = eval($(element).val() || 0);
        $element_row = $(element).closest('.row');
        $frame_size = eval($element_row.nextAll('div').find("input[id$='frame_size']:eq(0)").val() || 0);
        $overall_width_element = $element_row.nextAll('.row').find("input[id$='overall_width']:eq(0)");
        $overall_height_element = $element_row.nextAll('.row').find("input[id$='overall_height']:eq(0)");
        $overall_height_element.val($val+2*$frame_size);
        $element_row.nextAll('.row').find("input[id$='united_inches']:eq(0)").val(eval($overall_width_element.val())+eval($overall_height_element.val()));
    }

    frame_size=function(element){
        $val = eval($(element).val() || 0);
        $element_row = $(element).closest('.replaceable');
        if($element_row.length==0){
            $element_row= $(element).closest('.frame');
        }
        $width_element = $element_row.prevAll('.row').find("input[id$='glass_width']:eq(0)");
        $height_element = $element_row.prevAll('.row').find("input[id$='glass_height']:eq(0)");
        $overall_width_element = $element_row.nextAll('.row').find("input[id$='overall_width']:eq(0)");
        $overall_height_element = $element_row.nextAll('.row').find("input[id$='overall_height']:eq(0)");
        $overall_width_element.val(eval($width_element.val()||0)+2*$val);
        $overall_height_element.val(eval($height_element.val()||0)+2*$val);
        $element_row.nextAll('.row').find("input[id$='united_inches']:eq(0)").val(eval($overall_width_element.val())+eval($overall_height_element.val()));
    }

    overall_width=function(element){
        $val = eval($(element).val() || 0);
        $element_row = $(element).closest('.row');
        $frame_size = eval($element_row.prevAll('div').find("input[id$='frame_size']:eq(0)").val() || 0);
        $overall_height_element = $element_row.find("input[id$='overall_height']:eq(0)");
        $glass_width = $element_row.prevAll('.row').find("input[id$='glass_width']:eq(0)");
        $glass_width.val(eval($val||0)-2*$frame_size);
        $element_row.nextAll('.row').find("input[id$='united_inches']:eq(0)").val($val+eval($overall_height_element.val()));
        $mat_size = eval($element_row.prevAll('.row').find("input[id$='mat_size']:eq(0)").val()||0);
        $element_row.prevAll('div').find("input[id$='new_width'], input[id$='new_image_width']:eq(0)").val(eval($glass_width.val())-2*$mat_size);

    }

    overall_height=function(element){
        $val = eval($(element).val() || 0);
        $element_row = $(element).closest('.row');
        $frame_size = eval($element_row.prevAll('div').find("input[id$='frame_size']:eq(0)").val() || 0);
        $overall_width_element = $element_row.find("input[id$='overall_width']:eq(0)");
        $glass_height = $element_row.prevAll('.row').find("input[id$='glass_height']:eq(0)");
        $glass_height.val(eval($val||0)-2*$frame_size);
        $element_row.nextAll('.row').find("input[id$='united_inches']:eq(0)").val(eval($overall_width_element.val())+$val);
        $mat_size = eval($element_row.prevAll('.row').find("input[id$='mat_size']:eq(0)").val()||0);
        $element_row.prevAll('div').find("input[id$='new_height'], input[id$='new_image_height']:eq(0)").val(eval($glass_height.val())-2*$mat_size);
    }

    image_width = function(element){
        $val = eval($(element).val() || 0);
        $element_row = $(element).closest('.replaceable');
        if($element_row.length==0){
            $element_row= $(element).closest('.image');
        }
        $mat_size = eval($element_row.nextAll('.row').find("input[id$='mat_size']:eq(0)").val()||0);
        $glass_width = $element_row.nextAll('.row').find("input[id$='glass_width']:eq(0)");
        $glass_height = $element_row.nextAll('.row').find("input[id$='glass_height']:eq(0)");
        $glass_width.val($val+2*$mat_size);
        $element_row.nextAll('.row').find("input[id$='glass_united_inches']:eq(0)").val(eval($glass_width.val())+eval($glass_height.val()));
        glass_width($glass_width);
    }


    image_height = function(element){
        $val = eval($(element).val() || 0);
        $element_row = $(element).closest('.replaceable');
        if($element_row.length==0){
            $element_row= $(element).closest('.image');
        }
        $mat_size = eval($element_row.nextAll('.row').find("input[id$='mat_size']:eq(0)").val()||0);
        $glass_width = $element_row.nextAll('.row').find("input[id$='glass_width']:eq(0)");
        $glass_height = $element_row.nextAll('.row').find("input[id$='glass_height']:eq(0)");
        $glass_height.val($val+2*$mat_size);
        $element_row.nextAll('.row').find("input[id$='glass_united_inches']:eq(0)").val(eval($glass_width.val())+eval($glass_height.val()));
        glass_height($glass_height);

    }

    glass_width_artwork = function(element){
        $val = eval($(element).val() || 0);
        $element_row = $(element).closest('.row');
        $mat_size = eval($element_row.prevAll('.row').find("input[id$='mat_size']:eq(0)").val()||0);
        $image_width= $element_row.prevAll('div').find("input[id$='product_width']");
        $image_width.val($val- 2*$mat_size)
        $glass_height = $element_row.find("input[id$='glass_height']:eq(0)");
        $element_row.nextAll('.row').find("input[id$='glass_united_inches']:eq(0)").val($val+eval($glass_height.val()));
        glass_width(element);
    }

    glass_height_artwork = function(element){
        $val = eval($(element).val() || 0);
        $element_row = $(element).closest('.row');
        $mat_size = eval($element_row.prevAll('.row').find("input[id$='mat_size']:eq(0)").val()||0);
        $image_height= $element_row.prevAll('div').find("input[id$='product_height']");
        $image_height.val($val- 2*$mat_size)
        $glass_width = $element_row.find("input[id$='glass_width']:eq(0)");
        $element_row.nextAll('.row').find("input[id$='glass_united_inches']:eq(0)").val($val+eval($glass_width.val()));
        glass_height(element);
    }

    mat_size = function(element){
        $val = eval($(element).val() || 0);
        $element_row = $(element).closest('.row');
        $image_width= eval($element_row.prevAll('div').find("input[id$='product_width']").val() || 0);
        $image_height= eval($element_row.prevAll('div').find("input[id$='product_height']").val() || 0);
        $glass_width = $element_row.nextAll('.row').find("input[id$='glass_width']:eq(0)");
        $glass_height = $element_row.nextAll('.row').find("input[id$='glass_height']:eq(0)");
        $glass_width.val($image_width+2*$val);
        $glass_height.val($image_height+2*$val);
        $element_row.nextAll('.row').find("input[id$='glass_united_inches']:eq(0)").val(eval($glass_width.val())+eval($glass_height.val()));
        glass_width($glass_width);
        glass_height($glass_height);
    }

});
