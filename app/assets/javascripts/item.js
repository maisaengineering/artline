$(document).ready(function() {
    $("#Itemslist").change(function () {
        if (($(this).val() == "artwork") || ($(this).val() == "artificial_plant") || ($(this).val() == "lamp")) {
            $('.selected_item').show()
            var item = $(this).val()
            var url = "/item/ajax_load"
            $.ajax({
                method: "GET",
                url: url,
                data: {item: item}
            })
        }
        else {
            $('.selected_item').hide().empty()
        }
    });
});