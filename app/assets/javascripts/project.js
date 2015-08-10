$(document).ready(function() {
    $('#company_name').closest('.row').hide();
    $(".sales_rep").closest('.row').hide()
    $("#project_client_id").change(function(e){
        e.preventDefault();
        $(".company_client").empty()
        $val= $.trim($(this).val());
        $(this);

        if($val=='add'){
            $(this).closest('.row').remove();
            $('#company_name').closest('.row').show();

        }else{
            $.ajax({
                method: "GET",
                url: "/companies/"+$(this).val(),
                dataType: 'json',
                success: function(data){

                    fields = ["name", "address", "city", "state", "zip","phone", "email"]
                    $.each(fields,  function( index, value ) {
                        $("#company_"+value).val(data[value]);
                    })
                    $("#project_client_attention option").not('option:eq(0)').remove();
                    $.each(data["attention"], function(index, value){
                        $("#project_client_attention").append($("<option></option>").attr("value",value).text(value));
                    })
                    $("#project_client_attention").append($("<option></option>").attr("value","add").text("add"));
                }
            });
        }
    });
    $("#project_client_attention").change(function(){
        if($(this).val() == "add"){
            $(".company_client").append('<input type="text" name="company[new_attention_name]" id="new_company_attention" class="attention mbtm15" placeholder="Attention">')
        }
        else{
            $(".company_client").empty()
        }
    })


    $('#add_another_item').click(function(e){
        e.preventDefault();
        $source_element = $('#select_product').closest('.row').clone(true)[0];
        $($source_element).find('select').removeAttr('required');
        $('#add_another_item').closest('.row').before($source_element)
    })
});

getForm = function(element){
    $val= $.trim($(element).val());
    if($(element).attr('id')=='select_product'){
        $(element).closest('.row').nextAll().find('.child_product:first').remove();
    }
    $index = $('.select_product, .child_product').index(element);
    $(element).closest('.row').nextAll(".product_form:first").remove();
    if($val != "" ){

        var item = $val
        var url = "/product_ajax_load"
        $.ajax({
            method: "GET",
            url: url,
            data: {item: item, index: $index}
        })
    }

}

new_item = function(element){
    $val= $.trim($(element).val());
    $class_name= $(element).attr('data-name').toLowerCase();
    $index = $($(":input[class='"+$(element).attr('class')+"']")).index(element);
    $index = $('.'+$class_name).index($(element).closest('.row').next('.'+$class_name));
    if($val=='add'){
        var url = "/products/load_form"
        $.ajax({
            method: "GET",
            url: url,
            data: {item: $(element).attr('data-name'),
                index: $index,
                class_name: $class_name}
        })
    }else{
        if( ($class_name == "mouldingcompany") || ($class_name == "supplier")){
            return false;
        }
        $("."+$(element).attr('data-name').toLowerCase()).eq($index).html("");
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
                    case "lamp":
                        $elementRow = $(element).closest('.row').nextAll(".row");
                        $elementRow.find("select[id$='shade_id']:eq(0)").val(data.shade_id);
                        $elementRow.find("select[id$='bulb_id']:eq(0)").val(data.bulb_id);
                        break;
                    case "artificialplant":
                        $elementRow = $(element).closest('.row').nextAll(".row");
                        $elementRow.find("select[id$='fire_rating']:eq(0)").val(data.fire_rating);
                        $elementRow.find("select[id$='container_id']:eq(0)").val(data.container_id);
                        break;
                    case "frame":
                        $elementRow = $(element).closest('.row').nextAll(".row");
                        $elementRow.find("input[id$='category']:eq(0)").val(data.category);
                        $elementRow.find("input[id$='frame_size']:eq(0)").val(data.size);
                        $elementRow.find("input[id$='frame_size']:eq(0)").trigger('change');
                        break;
                    case "image":
                        $elementRow = $(element).closest('.row').nextAll(".replaceable");
                        $elementRow.find("input[id$='title']:eq(0)").val(data.title);
                        $elementRow.find("input[id$='width']:eq(0)").val(data.width);
                        $elementRow.find("input[id$='height']:eq(0)").val(data.height);
                        $elementRow.find("input[id$='width']:eq(0), input[id$='height']:eq(0)").trigger('change');
                        break;
                }
            }
        })
    }

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
        $(element).replaceWith('<input type="text" name="project[item_list][][product][new][' + $class_name + ']" id="project_item_list__'+ $class_name +'" class="form-control" placeholder="'+ place_holder +'"  required="required">')
    }
}


add_sales_rep = function(element){
  var name = $(element).val()
    if(name == "add"){
      $(".sales_rep").closest('.row').show()
      $(".sales_rep").append('<input type="text" name="project[new_sales_rep][name]" class="form-control" placeholder= "New Sales Representative" required="required">')
    }
    else{
        $(".sales_rep").empty().closest('.row').hide()
    }
}

delete_item = function(element){
    var id = $(element).attr("id")
    var items_list = $("#item_to_be_deleted").val()
    if(items_list == "")
    {
        $("#item_to_be_deleted").val(id + ',')
    }
    else{
        pre_item = $("#item_to_be_deleted").val()
        $("#item_to_be_deleted").val(pre_item + id + ',')
    }
    $(element).closest('.project_item').hide()
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
    $image_width= $element_row.prevAll('div').find("input[id$='new_width'], input[id$='new_image_width']:eq(0)");
    $image_width.val($val- 2*$mat_size)
    $glass_height = $element_row.find("input[id$='glass_height']:eq(0)");
    $element_row.nextAll('.row').find("input[id$='glass_united_inches']:eq(0)").val($val+eval($glass_height.val()));
    glass_width(element);
}

glass_height_artwork = function(element){
    $val = eval($(element).val() || 0);
    $element_row = $(element).closest('.row');
    $mat_size = eval($element_row.prevAll('.row').find("input[id$='mat_size']:eq(0)").val()||0);
    $image_height= $element_row.prevAll('div').find("input[id$='new_height'], input[id$='new_image_height']:eq(0)");
    $image_height.val($val- 2*$mat_size)
    $glass_width = $element_row.find("input[id$='glass_width']:eq(0)");
    $element_row.nextAll('.row').find("input[id$='glass_united_inches']:eq(0)").val($val+eval($glass_width.val()));
    glass_height(element);
}

mat_size = function(element){
    $val = eval($(element).val() || 0);
    $element_row = $(element).closest('.row');
    $image_width= eval($element_row.prevAll('div').find("input[id$='new_width'], input[id$='new_image_width']:eq(0)").val() || 0);
    $image_height= eval($element_row.prevAll('div').find("input[id$='new_height'], input[id$='new_image_height']:eq(0)").val() || 0);
    $glass_width = $element_row.nextAll('.row').find("input[id$='glass_width']:eq(0)");
    $glass_height = $element_row.nextAll('.row').find("input[id$='glass_height']:eq(0)");
    $glass_width.val($image_width+2*$val);
    $glass_height.val($image_height+2*$val);
    $element_row.nextAll('.row').find("input[id$='glass_united_inches']:eq(0)").val(eval($glass_width.val())+eval($glass_height.val()));
    glass_width($glass_width);
    glass_height($glass_height);
}