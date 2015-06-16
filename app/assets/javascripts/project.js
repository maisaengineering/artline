$(document).ready(function() {
    $('#company_name').closest('.row').hide();
    $("#project_client_id").change(function(e){
        e.preventDefault();
        $val= $.trim($(this).val());
        $(this);

        if($val=='other'){
            $(this).closest('.row').remove();
            $('#company_name').closest('.row').show();

        }else{
            $.ajax({
                method: "GET",
                url: "/companies/"+$(this).val(),
                dataType: 'json',
                success: function(data){
                    fields = ["name", "attention", "address", "city", "state", "zip","phone", "email"]
                    $.each(fields,  function( index, value ) {
                        $("#company_"+value).val(data[value]);
                    })
                }
            });
        }
    });


    $('#add_another_item').click(function(e){
        //e.preventDefault();
        $source_element = $('#select_product').closest('.row').clone(true)[0];
        $('#add_another_item').closest('.row').before($source_element)
        //$($source_element).wrap( "<div class='row'></div>" )

    })
});

getForm = function(element){
        $val= $.trim($(element).val());
        if($(element).attr('id')=='select_product'){
            $(element).closest('.row').nextAll().find('.child_product:first').remove();
        }
        $index = $('.select_product, .child_product').index(element);
    console.log($index);
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
