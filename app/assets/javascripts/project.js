$(document).ready(function() {
    $('#company_name').closest('.row').hide();
    $("#project_client_id").change(function(e){
        e.preventDefault();
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

                    $.each(data["attention"], function(index, value){
                        $("#project_client_attention").append($("<option></option>").attr("value",value).text(value));
                    });
                }
            });
        }
    });


    $('#add_another_item').click(function(e){
        //e.preventDefault();
        $source_element = $('#select_product').closest('.row').clone(true)[0];
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
        var item = $val
        var url = "/products/load_form"
        $.ajax({
            method: "GET",
            url: url,
            data: {item: $(element).attr('data-name'),
                index: $index,
                class_name: $class_name}
        })
    }else{
        $("."+$(element).attr('data-name').toLowerCase()).eq($index).html("");
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
        $("."+$(element).attr('data-name').toLowerCase()).eq($index).append('<input type="text" name="project[item_list][][' + $class_name + ']" id="project_item_list__'+ $class_name +'" class="form-control mbtm15" placeholder="'+ place_holder +'">')
    }
    else{
        $("."+$(element).attr('data-name').toLowerCase()).eq($index).html("").remove;
    }
}



add_attention = function(){
    $source_element = $("#field").closest('.row').clone(true)[0];
    $('#add-more').closest('.row').after($source_element)
    $($source_element).find('button').remove();
    $($source_element).find('.attention').val('');
}
