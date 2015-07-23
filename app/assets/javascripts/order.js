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

    $(".update_order").click(function(){
       var order_id = $("#order_id").val()
       var shipment_date = $("#shipment_date").val()
       var shipment_details = $("#shipment_details").val()
       var flag
       if( order_id == ""){
           $(".order_id_error").show()
           flag = true
       }
       else{
           $(".order_id_error").hide()
           flag = false
       }
       if( shipment_date == ""){
          $(".shipment_date_error").show()
           flag = true
       }
       else{
           $(".shipment_date_error").hide()
           flag = false
       }
       if( shipment_details == ""){
          $(".shipment_details_error").show()
           flag = true
       }
       else{
           $(".shipment_details_error").hide()
           flag = false
       }
       if(flag == true){
           return false;
       }
       else {
           url ="/orders/"+ order_id
           $.ajax({
             url: url,
             type: "PATCH",
             dataType: "json",
             data: {"order[shipment_date]": shipment_date,
                 "order[shipment_details]": shipment_details},
               success:function(data){
                   alert(data.message)
                   location.reload();
               }
           });
       }
    });
});