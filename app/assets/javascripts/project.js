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

});




