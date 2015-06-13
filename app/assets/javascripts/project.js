$(document).ready(function() {
    $("#new_company").hide()
    $("#new_attention").hide()
    $("#new_sales").hide()
    $("#Company").change(function () {
        if ($("#Company").val() == "New Company") {
            $("#new_company").fadeIn("slow")
        }
        else {
            $("#new_company").val("")
            $("#new_company").fadeOut()
        }
    });
    $("#Attention").change(function () {
        if ($("#Attention").val() == "New Attention") {
            $("#new_attention").fadeIn("slow")
        }
        else {
            $("#new_attention").val("")
            $("#new_attention").fadeOut()
        }
    });
    $("#Sales").change(function () {
        if ($("#Sales").val() == "New") {
            $("#new_sales").fadeIn("slow")
        }
        else {
            $("#new_sales").val("")
            $("#new_sales").fadeOut()
        }
    });


    $("#Select_Product").change(function () {
        if ( $(this).val() != "" ) {
            $('.display_item').show()
            var item = $(this).val()
            var url = "/product_ajax_load"
            $.ajax({
                method: "GET",
                url: url,
                data: {item: item}
            })
        }
        else {
            $('.display_item').hide()
        }
    });

});