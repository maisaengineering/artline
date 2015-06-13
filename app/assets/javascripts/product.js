$(document).ready(function() {
    $("#Itemslist").change(function () {
        if (($(this).val() == "Artwork") || ($(this).val() == "ArtificialPlant") || ($(this).val() == "Lamp")) {
            $('.selected_item').show()
            var item = $(this).val()
            var url = "/products/load_form"
            $.ajax({
                method: "GET",
                url: url,
                script: 'js',
                data: {item: item}
            })
        }
        else {
            $('.selected_item').html("<h2>No form</h2>")
        }
    });
});