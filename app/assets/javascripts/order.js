$(document).ready(function() {
    var li_count = $("ol li").length
    var stage = $("#stage").val()
    $('ol li').each(function(i)
    {
        var index = i + 1;
        if(index <= stage){
            $(this).addClass("progtrckr-done")
        }
        else{
            $(this).addClass("progtrckr-todo")
        }
    });


    $(".show_details").click(function () {
        $(this).hide()
        $(".hide_details").show()
        $(".order_desc").fadeIn()
    });

    $(".hide_details").click(function () {
        $(this).hide()
        $(".show_details").show()
        $(".order_desc").hide()
    });
});